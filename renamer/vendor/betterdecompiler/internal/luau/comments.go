package luau

import (
	"fmt"
	"strings"
)

// inferFuncBody infers a concise camelCase function name from the direct
// operations inside f.Toks[s:e] (skipping nested function literals).
func (f *File) inferFuncBody(s, e int) string {
	info := f.scanSpan(s, e)
	switch {
	case info.methods["JSONDecode"] && info.globals["readfile"]:
		return "loadJsonFile"
	case info.methods["JSONEncode"] && (info.globals["writefile"] || info.globals["appendfile"]):
		return "saveJsonFile"
	case info.methods["Raycast"]:
		return "raycastSurface"
	case info.methods["Disconnect"] && info.dotted["table.clear"]:
		return "disconnectAll"
	case info.methods["Disconnect"] && len(info.methods) <= 2:
		return "disconnectSignal"
	case info.globals["fireproximityprompt"]:
		return "triggerProximityPrompt"
	case info.globals["firetouchinterest"]:
		return "triggerTouchInterest"
	case info.methods["Teleport"] || info.methods["TeleportToPlaceInstance"]:
		return "teleportToServer"
	case info.methods["HttpGet"] && info.globals["loadstring"]:
		return "loadRemoteChunk"
	case info.methods["HttpGet"] || info.methods["HttpGetAsync"]:
		return "fetchHttpBody"
	case (info.globals["request"] || info.globals["http_request"] || info.dotted["syn.request"]) && !info.methods["JSONDecode"]:
		return "resolveHttpRequest"
	case info.dotted["syn.websocket"] || info.dotted["WebSocket.connect"] || info.dotted["WebSocket.new"]:
		return "resolveWebSocket"
	case info.methods["FireServer"] && info.remoteName != "":
		return "fire" + pascal(info.remoteName)
	case info.methods["InvokeServer"] && info.remoteName != "":
		return "invoke" + pascal(info.remoteName)
	case info.globals["setclipboard"] || info.globals["toclipboard"]:
		return "copyToClipboard"
	case info.methods["GetChildren"] && info.fields["Magnitude"] && info.firstChildArg != "":
		return "findNearest" + pascal(info.firstChildArg)
	case info.methods["PivotTo"] && len(info.methods) <= 3:
		return "pivotCharacterTo"
	case len(info.uiClasses) > 0 && info.uiClasses[0] == "ScreenGui":
		return "createScreenGui"
	}
	return ""
}

type spanSummary struct {
	methods       map[string]bool
	methodOrder   []string
	globals       map[string]bool
	dotted        map[string]bool
	fields        map[string]bool
	services      []string
	uiClasses     []string
	events        []string
	remoteName    string
	firstChildArg string
	hasLoop       bool
	hasPcall      bool
}

func (f *File) scanSpan(s, e int) spanSummary {
	out := spanSummary{
		methods: map[string]bool{},
		globals: map[string]bool{},
		dotted:  map[string]bool{},
		fields:  map[string]bool{},
	}
	seenSvc := map[string]bool{}
	seenUI := map[string]bool{}
	seenEv := map[string]bool{}

	// Skip parameter list `( ... )` at start of function body
	i := s
	if i < e && f.Toks[i].Kind == Op && f.Toks[i].Text == "(" {
		depth := 0
		for ; i < e; i++ {
			if f.Toks[i].Kind == Op && f.Toks[i].Text == "(" {
				depth++
			} else if f.Toks[i].Kind == Op && f.Toks[i].Text == ")" {
				depth--
				if depth == 0 {
					i++
					break
				}
			}
		}
	}

	fnDepth := 0
	for ; i < e; i++ {
		tk := f.Toks[i]
		if tk.Kind == Keyword {
			switch tk.Text {
			case "function":
				fnDepth++
				continue
			case "if", "for", "while", "do":
				if fnDepth > 0 {
					fnDepth++
				} else if tk.Text == "for" || tk.Text == "while" {
					out.hasLoop = true
				}
			case "end":
				if fnDepth > 0 {
					fnDepth--
					continue
				}
			}
		}
		if fnDepth > 0 {
			continue
		}

		// Method call `:Method(...)`
		if tk.Kind == Op && tk.Text == ":" && i+1 < e && f.Toks[i+1].Kind == Name {
			m := f.Toks[i+1].Text
			if !out.methods[m] {
				out.methods[m] = true
				out.methodOrder = append(out.methodOrder, m)
			}
			_, arg, _ := f.skipArgs(i+2, e)
			if m == "GetService" && arg != "" && !seenSvc[arg] {
				seenSvc[arg] = true
				out.services = append(out.services, arg)
			}
			if childFinders[m] && arg != "" && out.firstChildArg == "" {
				out.firstChildArg = arg
			}
			if (m == "FireServer" || m == "InvokeServer") && out.remoteName == "" && i >= 1 && f.Toks[i-1].Kind == Name {
				out.remoteName = f.Toks[i-1].Text
			}
			if connectMethods[m] && i >= 1 && f.Toks[i-1].Kind == Name {
				ev := f.Toks[i-1].Text
				if !seenEv[ev] {
					seenEv[ev] = true
					out.events = append(out.events, ev)
				}
			}
		}

		// Field access `.Field`
		if tk.Kind == Op && tk.Text == "." && i+1 < e && f.Toks[i+1].Kind == Name {
			fld := f.Toks[i+1].Text
			out.fields[fld] = true
			if i >= 1 && f.Toks[i-1].Kind == Name {
				pair := f.Toks[i-1].Text + "." + fld
				out.dotted[pair] = true
				if pair == "Instance.new" {
					_, arg, _ := f.skipArgs(i+2, e)
					if arg != "" && !seenUI[arg] {
						seenUI[arg] = true
						out.uiClasses = append(out.uiClasses, arg)
					}
				}
			}
		}

		// Global calls (`pcall`, `readfile`, `writefile`, ...)
		if tk.Kind == Name && f.Resolve[i] == Global {
			out.globals[tk.Text] = true
			if tk.Text == "pcall" || tk.Text == "xpcall" {
				out.hasPcall = true
			}
		}
	}
	return out
}

// SuggestComments produces clean, human-readable contextual comments (1-based
// line -> comment text) for major sections, static data tables, and functions.
// Level may be "none", "light", or "detailed". Existing comments are respected
// so running the renamer multiple times is idempotent.
func (f *File) SuggestComments(level string) map[int]string {
	if level == "" || level == "none" {
		return nil
	}
	detailed := level == "detailed"
	commentedAbove := map[int]bool{}
	for _, c := range f.Comments {
		endLine := c.Line + strings.Count(c.Text, "\n")
		commentedAbove[endLine] = true
		commentedAbove[endLine+1] = true
	}

	out := map[int]string{}
	add := func(line int, text string) {
		if line < 1 || text == "" || commentedAbove[line] || out[line] != "" {
			return
		}
		out[line] = text
		commentedAbove[line] = true
	}

	// 1. Top-level / bootstrap landmarks & large static preset tables
	svcMarked := false
	envMarked := false
	for _, b := range f.Bindings {
		if b.Decl < 0 {
			continue
		}
		declLine := f.Toks[b.Decl].Line
		if !envMarked && b.Init[0] >= 0 {
			inf := f.scanSpan(b.Init[0], b.Init[1])
			if inf.globals["getgenv"] || inf.globals["gethui"] {
				add(declLine, "Bootstrap executor global environment and UI container")
				envMarked = true
				continue
			}
			if !svcMarked && len(inf.services) > 0 && declLine <= 80 {
				add(declLine, "Roblox service references")
				svcMarked = true
			}
		}
		// Large static table literal (`local eggPresets = { ... }`)
		if b.Kind == BindLocal && len(b.Name) >= 3 && b.Init[0] >= 0 && b.Init[1] > b.Init[0] && f.Toks[b.Init[0]].Text == "{" {
			tblLine := f.Toks[b.Init[0]].Line
			endLine := f.Toks[b.Init[1]-1].Line
			spanLines := endLine - tblLine + 1
			if spanLines >= 25 && !LooksGenerated(b.Name) {
				add(tblLine, fmt.Sprintf("Static configuration/preset table: %s (%d lines)", b.Name, spanLines))
			}
		}
	}

	// 2. Contextual function doc-comments
	minSpan := 10
	if detailed {
		minSpan = 5
	}
	for _, fn := range f.Funcs {
		span := fn.EndLine - fn.Line + 1
		if span < minSpan {
			continue
		}
		summary := f.describeFunc(fn, detailed)
		if summary != "" {
			add(fn.Line, summary)
		}
	}

	// 3. In detailed mode, annotate top-level / module event listeners
	if detailed {
		for i := 1; i+2 < len(f.Toks); i++ {
			if f.Toks[i].Kind == Op && f.Toks[i].Text == ":" && connectMethods[f.Toks[i+1].Text] && f.Toks[i-1].Kind == Name {
				ev := f.Toks[i-1].Text
				line := f.Toks[i].Line
				add(line, fmt.Sprintf("Event listener: %s:%s", ev, f.Toks[i+1].Text))
			}
		}
	}
	return out
}

func (f *File) describeFunc(fn FuncSpan, detailed bool) string {
	inf := f.scanSpan(fn.Body[0], fn.Body[1])
	span := fn.EndLine - fn.Line + 1
	switch {
	case inf.methods["Raycast"]:
		return "Casts raycast in workspace and computes ground/surface hit position"
	case inf.methods["Disconnect"] && inf.dotted["table.clear"]:
		return "Disconnects all tracked RBXScriptConnections and clears the list"
	case inf.methods["JSONDecode"] && inf.globals["readfile"]:
		return "Reads and decodes JSON configuration from executor file storage"
	case inf.methods["JSONEncode"] && (inf.globals["writefile"] || inf.globals["appendfile"]):
		return "Serializes data to JSON and writes it to executor file storage"
	case inf.dotted["syn.websocket"] || inf.dotted["WebSocket.connect"] || inf.dotted["WebSocket.new"]:
		return "Resolves available executor WebSocket constructor (syn / WebSocket)"
	case (inf.globals["request"] || inf.globals["http_request"] || inf.dotted["syn.request"]) && !inf.methods["JSONDecode"]:
		return "Resolves executor HTTP request handler with cross-executor fallbacks"
	case inf.methods["RequestAsync"] || (inf.methods["JSONEncode"] && (inf.globals["request"] || inf.globals["http_request"])):
		return "Sends JSON HTTP request through executor transport"
	case inf.methods["FireServer"] && inf.remoteName != "":
		return fmt.Sprintf("Fires remote event %s on the server", inf.remoteName)
	case inf.methods["InvokeServer"] && inf.remoteName != "":
		return fmt.Sprintf("Invokes remote function %s and processes server response", inf.remoteName)
	case inf.methods["Teleport"] || inf.methods["TeleportToPlaceInstance"]:
		return "Handles server teleport / place instance hop via TeleportService"
	case inf.methods["CreatePath"] || inf.methods["ComputeAsync"] || inf.methods["GetWaypoints"]:
		return "Computes navigation path waypoints and guides character movement"
	case inf.globals["fireproximityprompt"]:
		return "Triggers ProximityPrompt interaction and waits for completion"
	case inf.globals["firetouchinterest"]:
		return "Simulates TouchTransmitter contact on target BasePart"
	case inf.methods["GetChildren"] && inf.fields["Magnitude"] && inf.firstChildArg != "":
		return fmt.Sprintf("Scans children for %q and selects the nearest target by distance", inf.firstChildArg)
	case inf.fields["AssemblyLinearVelocity"] || inf.fields["AssemblyAngularVelocity"]:
		return "Drives character physics velocity toward target destination"
	case inf.methods["MoveTo"] && inf.fields["MoveToFinished"]:
		return "Walks Humanoid to target point and awaits MoveToFinished"
	case inf.methods["PivotTo"] && span <= 60:
		return "Updates character/model world CFrame via PivotTo"
	case inf.methods["GetPlayers"] && len(inf.events) > 0:
		return fmt.Sprintf("Tracks players and hooks %s events", strings.Join(limitSlice(inf.events, 2), ", "))
	case len(inf.uiClasses) >= 2:
		return fmt.Sprintf("Builds UI components (%s)", strings.Join(limitSlice(inf.uiClasses, 3), ", "))
	case len(inf.uiClasses) == 1:
		return fmt.Sprintf("Creates and configures %s UI instance", inf.uiClasses[0])
	case inf.methods["Play"] && len(inf.events) == 1 && inf.events[0] == "Completed":
		return "Plays UI/property tween transition and hooks Completed callback"
	case inf.dotted["os.clock"] && inf.hasLoop && span <= 35:
		return "Runs polling loop until condition succeeds or timeout expires (os.clock)"
	case inf.dotted["Color3.fromRGB"] || inf.dotted["Color3.new"]:
		if span <= 80 && !inf.hasLoop {
			return "Parses and normalizes RGB input into a Color3 value"
		}
	case len(inf.events) > 0:
		return fmt.Sprintf("Registers %s signal callback(s)", strings.Join(limitSlice(inf.events, 3), ", "))
	case detailed && len(inf.methodOrder) > 0:
		return fmt.Sprintf("Helper routine (%s) — calls :%s", fn.Name, strings.Join(limitSlice(inf.methodOrder, 3), ", :"))
	}
	return ""
}

func limitSlice(xs []string, n int) []string {
	if len(xs) <= n {
		return xs
	}
	return xs[:n]
}
