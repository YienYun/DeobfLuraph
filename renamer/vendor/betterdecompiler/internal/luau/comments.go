package luau

import (
	"fmt"
	"sort"
	"strconv"
	"strings"
)

// inferFuncBody infers a concise camelCase function name from the direct
// operations inside f.Toks[s:e] (skipping nested function literals).
func (f *File) inferFuncBody(s, e int) string {
	return f.inferFuncBodyNamed(s, e, nil)
}

func (f *File) inferFuncBodyNamed(s, e int, nameOf func(int) string) string {
	resolveName := func(tokIdx int) string {
		if tokIdx < 0 || tokIdx >= len(f.Toks) {
			return ""
		}
		if nameOf != nil && f.Resolve[tokIdx] >= 0 {
			return nameOf(f.Resolve[tokIdx])
		}
		return f.Toks[tokIdx].Text
	}
	info := f.scanSpanNamed(s, e, resolveName)
	switch {
	case info.methods["JSONDecode"] && info.globals["readfile"]:
		return "loadJsonFile"
	case info.methods["JSONEncode"] && (info.globals["writefile"] || info.globals["appendfile"]):
		return "saveJsonFile"
	case info.globals["writefile"] && !info.globals["readfile"]:
		return "saveFileData"
	case info.globals["readfile"] && !info.globals["writefile"]:
		return "readFileData"
	case info.methods["Raycast"]:
		return "raycastSurface"
	case info.methods["Disconnect"] && info.dotted["table.clear"]:
		return "disconnectAll"
	case info.methods["Disconnect"] && len(info.methods) <= 2:
		return "disconnectSignal"
	case info.methods["Destroy"] && len(info.methods) <= 2 && info.hasLoop:
		return "destroyItems"
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
	case info.methods["MoveTo"] && len(info.methods) <= 3:
		return "moveToTarget"
	case info.methods["Wait"] && len(info.methods) == 1 && info.waitTarget != "":
		return "wait" + pascal(info.waitTarget)
	case info.methods["GetService"] && len(info.methods) == 1:
		return "getService"
	case info.fields["CameraSubject"] && len(info.methods) <= 2:
		return "setCameraSubject"
	case info.fields["FontFace"] && (info.fields["TextColor3"] || info.fields["TextScaled"]):
		return "applyTextStyle"
	case info.fields["Visible"] && (info.fields["AbsolutePosition"] || info.fields["CanvasPosition"]):
		return "updateViewportVisibility"
	case info.fields["BackgroundTransparency"] && len(info.methods) <= 2 && !info.hasLoop:
		return "updateBackgroundAlpha"
	case info.fields["BackgroundTransparency"] && info.hasLoop && len(info.methods) <= 2:
		return "setFramesAlpha"
	case (info.dotted["string.format"] || info.globals["stringFormat"]) && info.methods["gsub"]:
		return "formatDecimal"
	case info.methods["match"] && info.globals["tonumber"]:
		return "parseNumberText"
	case info.wrappedFn != "" && !LooksGenerated(info.wrappedFn) && len(info.wrappedFn) > 1:
		return info.wrapperPrefix + pascal(info.wrappedFn)
	case info.uiWidgetName != "":
		return "create" + pascal(info.uiWidgetName)
	case len(info.uiClasses) > 0 && info.uiClasses[0] == "ScreenGui":
		return "createScreenGui"
	case len(info.uiClasses) == 1 && len(info.methods) == 0:
		return "create" + pascal(info.uiClasses[0])
	case len(info.services) >= 3 && e-s > 400:
		return "runMainHub"
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
	waitTarget    string
	wrappedFn     string
	wrapperPrefix string
	uiWidgetName  string
	hasLoop       bool
	hasPcall      bool
}

func (f *File) scanSpan(s, e int) spanSummary {
	return f.scanSpanNamed(s, e, func(idx int) string { return f.Toks[idx].Text })
}

func (f *File) scanSpanNamed(s, e int, resolveName func(int) string) spanSummary {
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
				out.remoteName = resolveName(i - 1)
			}
			if m == "Wait" && out.waitTarget == "" && i >= 1 && f.Toks[i-1].Kind == Name {
				cand := resolveName(i - 1)
				if !LooksGenerated(cand) && len(cand) > 1 {
					out.waitTarget = cand
				}
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
				if (pair == "task.spawn" || pair == "task.defer") && i+4 < e && f.Toks[i+2].Text == "(" && f.Toks[i+3].Kind == Name {
					out.wrappedFn = resolveName(i + 3)
					out.wrapperPrefix = "spawn"
				}
			}
		}

		// UI factory call `c("Frame", {..., Name = "Switch", ...})`
		if tk.Kind == Op && tk.Text == "(" && i >= 1 && f.Toks[i-1].Kind == Name && i+1 < e && f.Toks[i+1].Kind == String {
			cls := unquote(f.Toks[i+1].Text)
			if uiClassNames[cls] && out.uiWidgetName == "" {
				endCall := f.matchingClose(i, e)
				if endCall > i {
					if prop := f.tableNameProp(i+1, endCall); prop != "" && prop != "OFF" && prop != "ON" && prop != "Hold" && prop != "Color" {
						out.uiWidgetName = prop
					}
				}
			}
		}

		// Global calls (`pcall`, `readfile`, `writefile`, ...)
		if tk.Kind == Name && f.Resolve[i] == Global {
			out.globals[tk.Text] = true
			if tk.Text == "pcall" || tk.Text == "xpcall" {
				out.hasPcall = true
				if e-s < 120 && i+3 < e && f.Toks[i+1].Text == "(" && f.Toks[i+2].Kind == Name &&
					(f.Toks[i+3].Text == ")" || f.Toks[i+3].Text == ",") {
					cand := resolveName(i + 2)
					if !LooksGenerated(cand) && len(cand) > 1 && !reserved[cand] {
						out.wrappedFn = cand
						out.wrapperPrefix = "safe"
					}
				}
			}
		} else if tk.Kind == Name && f.Resolve[i] >= 0 {
			rn := resolveName(i)
			if rn == "stringFormat" {
				out.globals["stringFormat"] = true
			}
		}
	}
	return out
}

// RenameContextFields renames generated field names (e.g. `ctx.fn11`, `ctx.slot33`, `ctx2.n2`)
// on local context tables (`local ctx = {}`) when every reference to that table uses static `.Field`
// property syntax (never dynamic `ctx[...]` indexing), guaranteeing 100% collision-free safety.
func (f *File) RenameContextFields() (string, int) {
	type edit struct {
		start, end int
		text       string
	}
	var edits []edit
	renamedFields := 0

	nameOf := func(id int) string {
		if id >= 0 && id < len(f.Bindings) {
			return f.Bindings[id].Name
		}
		return ""
	}

	for _, b := range f.Bindings {
		if b.Kind != BindLocal || b.Init[0] < 0 {
			continue
		}
		// Must be initialized to `{}` or `{...}` table literal
		s, e := b.Init[0], b.Init[1]
		if e-s < 2 || f.Toks[s].Text != "{" || f.Toks[e-1].Text != "}" {
			continue
		}
		if len(b.Refs) < 4 {
			continue
		}
		// Verify every non-decl ref is strictly `ctx.Field` (no dynamic `ctx[k]`, no passing `ctx` raw)
		pureDot := true
		existingFields := map[string]bool{}
		fieldToks := map[string][]int{}
		fieldAssigns := map[string][][2]int{}

		for _, r := range b.Refs {
			if r == b.Decl {
				continue
			}
			if r+2 >= len(f.Toks) || f.Toks[r+1].Kind != Op || f.Toks[r+1].Text != "." || f.Toks[r+2].Kind != Name {
				pureDot = false
				break
			}
			fld := f.Toks[r+2].Text
			existingFields[fld] = true
			fieldToks[fld] = append(fieldToks[fld], r+2)

			// Check if `ctx.fld = <expr>`
			if r+4 < len(f.Toks) && f.Toks[r+3].Kind == Op && f.Toks[r+3].Text == "=" {
				rhsStart := r + 4
				if f.Toks[rhsStart].Kind == Keyword && f.Toks[rhsStart].Text == "function" {
					endFn := f.findFunctionEnd(rhsStart)
					if endFn > rhsStart {
						fieldAssigns[fld] = append(fieldAssigns[fld], [2]int{rhsStart + 1, endFn})
					}
				} else {
					// Single-line simple expression up to end of line
					ln := f.Toks[rhsStart].Line
					rhsEnd := rhsStart
					for rhsEnd < len(f.Toks) && f.Toks[rhsEnd].Line == ln && f.Toks[rhsEnd].Text != ";" {
						rhsEnd++
					}
					if rhsEnd > rhsStart {
						fieldAssigns[fld] = append(fieldAssigns[fld], [2]int{rhsStart, rhsEnd})
					}
				}
			}
		}
		if !pureDot {
			continue
		}

		// Sort generated fields deterministically
		var genFields []string
		for fld := range fieldToks {
			if LooksGenerated(fld) {
				genFields = append(genFields, fld)
			}
		}
		sort.Strings(genFields)

		for _, fld := range genFields {
			spans := fieldAssigns[fld]
			if len(spans) == 0 {
				continue
			}
			var cand string
			for _, sp := range spans {
				if sp[0] > 0 && f.Toks[sp[0]-1].Kind == Keyword && f.Toks[sp[0]-1].Text == "function" {
					cand = f.inferFuncBodyNamed(sp[0], sp[1], nameOf)
				} else {
					cand = f.inferExpr(sp[0], sp[1], nameOf)
				}
				if cand != "" {
					break
				}
			}
			if cand == "" || !ValidName(cand) || LooksGenerated(cand) {
				continue
			}
			finalName := cand
			for n := 2; existingFields[finalName]; n++ {
				finalName = cand + strconv.Itoa(n)
			}
			existingFields[finalName] = true
			renamedFields++
			for _, ti := range fieldToks[fld] {
				tk := f.Toks[ti]
				edits = append(edits, edit{tk.Start, tk.End, finalName})
			}
		}
	}

	if len(edits) == 0 {
		return f.Src, 0
	}
	sort.Slice(edits, func(i, j int) bool { return edits[i].start < edits[j].start })
	var sb strings.Builder
	sb.Grow(len(f.Src) + len(edits)*8)
	last := 0
	for _, ed := range edits {
		sb.WriteString(f.Src[last:ed.start])
		sb.WriteString(ed.text)
		last = ed.end
	}
	sb.WriteString(f.Src[last:])
	return sb.String(), renamedFields
}

func (f *File) findFunctionEnd(fnTok int) int {
	depth := 0
	for i := fnTok; i < len(f.Toks); i++ {
		if f.Toks[i].Kind == Keyword {
			switch f.Toks[i].Text {
			case "function", "if", "for", "while", "do":
				depth++
			case "end":
				depth--
				if depth == 0 {
					return i + 1
				}
			}
		}
	}
	return -1
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
