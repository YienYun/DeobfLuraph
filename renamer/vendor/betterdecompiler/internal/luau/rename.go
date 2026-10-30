package luau

import (
	"regexp"
	"sort"
	"strconv"
	"strings"
)

var identRe = regexp.MustCompile(`^[A-Za-z_][A-Za-z0-9_]*$`)

// reserved names are never used as rename targets: keywords, contextual
// keywords and the globals every Roblox script relies on.
var reserved = map[string]bool{}

func init() {
	for _, s := range strings.Fields(`
		self type typeof continue export goto _ _G _ENV _VERSION
		game workspace Workspace script plugin shared Enum Instance Game
		math string table coroutine task debug os utf8 bit32 buffer vector
		print warn error assert pairs ipairs next select tostring tonumber require
		pcall xpcall ypcall setmetatable getmetatable rawget rawset rawequal rawlen
		unpack newproxy gcinfo collectgarbage loadstring getfenv setfenv
		wait delay spawn tick time elapsedTime settings UserSettings version stats
		Vector3 Vector2 Vector3int16 Vector2int16 CFrame Color3 UDim UDim2 BrickColor
		Ray TweenInfo NumberSequence NumberSequenceKeypoint NumberRange ColorSequence
		ColorSequenceKeypoint Rect Region3 Region3int16 RaycastParams OverlapParams
		Random DateTime Font PhysicalProperties Axes Faces PathWaypoint
		SharedTable Content CatalogSearchParams DockWidgetPluginGuiInfo
		getgenv getrenv getsenv getreg getgc decompile request http_request syn
		http fluxus krnl WebSocket Drawing crypt cache gethui identifyexecutor getexecutorname
		readfile writefile appendfile makefolder delfile delfolder isfile isfolder listfiles
		loadfile dofile getcustomasset setclipboard toclipboard
		fireproximityprompt firetouchinterest fireclickdetector firesignal getconnections
		hookfunction hookmetamethod getnamecallmethod setnamecallmethod checkcaller
		newcclosure islclosure iscclosure clonefunction restorefunction
		getrawmetatable setrawmetatable setreadonly isreadonly
		sethiddenproperty gethiddenproperty setfpscap queue_on_teleport
		getinstances getnilinstances getloadedmodules getrunningscripts getscripts
	`) {
		reserved[s] = true
	}
}

// ValidName reports whether s can be used as a new variable name.
func ValidName(s string) bool {
	return len(s) <= 64 && identRe.MatchString(s) && !keywords[s] && !reserved[s]
}

// Renamable reports whether a binding may be renamed (implicit self cannot).
func (b *Binding) Renamable() bool { return b.Decl >= 0 }

// applyNames rewrites the source with the given binding names. No checks.
func (f *File) applyNames(target map[int]string) string {
	type repl struct {
		start, end int
		text       string
	}
	var reps []repl
	for id, name := range target {
		for _, r := range f.Bindings[id].Refs {
			t := f.Toks[r]
			reps = append(reps, repl{t.Start, t.End, name})
		}
	}
	if len(reps) == 0 {
		return f.Src
	}
	sort.Slice(reps, func(i, j int) bool { return reps[i].start < reps[j].start })
	var sb strings.Builder
	sb.Grow(len(f.Src) + len(reps)*8)
	last := 0
	for _, r := range reps {
		sb.WriteString(f.Src[last:r.start])
		sb.WriteString(r.text)
		last = r.end
	}
	sb.WriteString(f.Src[last:])
	return sb.String()
}

func (f *File) namesWith(target map[int]string) []string {
	names := make([]string, len(f.Toks))
	for i, t := range f.Toks {
		names[i] = t.Text
	}
	for id, n := range target {
		for _, r := range f.Bindings[id].Refs {
			names[r] = n
		}
	}
	return names
}

// Rename applies the requested renames (binding ID -> new name) and returns the
// new source plus the names that were actually applied.
//
// Every rename is verified: the renamed program is re-resolved and each
// identifier must still refer to exactly the same variable (or global) as
// before. Renames that would capture or shadow another variable get a numeric
// suffix (player -> player2); renames that cannot be made safe are dropped.
// The result therefore always behaves identically to the input.
func (f *File) Rename(want map[int]string) (string, map[int]string) {
	base := map[int]string{}
	for id, n := range want {
		if id < 0 || id >= len(f.Bindings) {
			continue
		}
		b := f.Bindings[id]
		if !b.Renamable() || n == b.Name || !ValidName(n) {
			continue
		}
		base[id] = n
	}
	target := make(map[int]string, len(base))
	for id, n := range base {
		target[id] = n
	}
	used := map[string]bool{}
	for _, t := range f.Toks {
		if t.Kind == Name {
			used[t.Text] = true
		}
	}
	nextSuffix := map[string]int{}
	allocUnique := func(bname string) string {
		n := nextSuffix[bname]
		if n < 2 {
			n = 2
		}
		for {
			cand := bname + strconv.Itoa(n)
			n++
			if !used[cand] {
				nextSuffix[bname] = n
				used[cand] = true
				return cand
			}
		}
	}

	attempts := map[int]int{}
	for iter := 0; iter < 64 && len(target) > 0; iter++ {
		p, err := analyze(f.Toks, f.namesWith(target))
		if err != nil { // cannot happen for identifier-only changes, but be safe
			return f.Src, map[int]string{}
		}
		culpritList := make([]int, 0)
		culprits := map[int]bool{}
		for i, orig := range f.Resolve {
			if orig == NotVar {
				continue
			}
			now := p.resolve[i]
			if now == orig {
				continue
			}
			// Blame the renamed binding that captured the reference, else the
			// renamed binding that lost it.
			if _, ok := target[now]; ok && now >= 0 {
				if !culprits[now] {
					culprits[now] = true
					culpritList = append(culpritList, now)
				}
			} else if _, ok := target[orig]; ok && orig >= 0 {
				if !culprits[orig] {
					culprits[orig] = true
					culpritList = append(culpritList, orig)
				}
			}
		}
		if len(culpritList) == 0 {
			return f.applyNames(target), target
		}
		sort.Ints(culpritList)
		for _, id := range culpritList {
			attempts[id]++
			if attempts[id] > 32 {
				delete(target, id)
				continue
			}
			if attempts[id] == 1 {
				// First try simple base2 if completely unused, else allocate guaranteed-unused suffix
				cand2 := base[id] + "2"
				if !used[cand2] {
					used[cand2] = true
					if nextSuffix[base[id]] < 3 {
						nextSuffix[base[id]] = 3
					}
					target[id] = cand2
					continue
				}
			}
			target[id] = allocUnique(base[id])
		}
	}
	if len(target) == 0 {
		return f.Src, target
	}
	// Did not converge: fall back to only the renames that are safe alone.
	safe := map[int]string{}
	for id, n := range target {
		trial := map[int]string{id: n}
		if p, err := analyze(f.Toks, f.namesWith(trial)); err == nil && sameResolution(f.Resolve, p.resolve) {
			safe[id] = n
		}
	}
	if p, err := analyze(f.Toks, f.namesWith(safe)); err != nil || !sameResolution(f.Resolve, p.resolve) {
		return f.Src, map[int]string{}
	}
	return f.applyNames(safe), safe
}

func sameResolution(a, b []int) bool {
	for i := range a {
		if a[i] != NotVar && a[i] != b[i] {
			return false
		}
	}
	return true
}

// UniqueKeys gives every renamable binding a name that is unique in the file,
// so that prompts can refer to each variable unambiguously even when the
// decompiler reused names like p1 across functions. It returns the keyed
// source and the key of each binding.
func (f *File) UniqueKeys() (string, map[int]string) {
	used := map[string]bool{}
	for _, t := range f.Toks {
		if t.Kind == Name {
			used[t.Text] = true
		}
	}
	count := map[string]int{}
	for _, b := range f.Bindings {
		if b.Renamable() {
			count[b.Name]++
		}
	}
	globals := map[string]bool{}
	for i, r := range f.Resolve {
		if r == Global {
			globals[f.Toks[i].Text] = true
		}
	}
	keys := map[int]string{}
	target := map[int]string{}
	seen := map[string]int{}
	for _, b := range f.Bindings {
		if !b.Renamable() {
			continue
		}
		if count[b.Name] == 1 && !globals[b.Name] {
			keys[b.ID] = b.Name
			continue
		}
		seen[b.Name]++
		var k string
		for n := seen[b.Name]; ; n++ {
			k = b.Name + "_" + strconv.Itoa(n)
			if !used[k] {
				seen[b.Name] = n
				break
			}
		}
		used[k] = true
		keys[b.ID] = k
		target[b.ID] = k
	}
	return f.applyNames(target), keys
}

// InsertComments inserts "-- text" comment lines above the given 1-based
// line numbers, matching the line's indentation. Lines that start inside a
// multi-line string or comment are skipped so program behavior is unchanged.
func (f *File) InsertComments(src string, comments map[int]string) string {
	if len(comments) == 0 {
		return src
	}
	lineStart := []int{0, 0} // 1-based
	for i := 0; i < len(src); i++ {
		if src[i] == '\n' {
			lineStart = append(lineStart, i+1)
		}
	}
	// Multi-line spans in src. Renames never add or remove newlines, so line
	// numbers of f and src agree; recompute spans from src for exact offsets.
	var spans [][2]int
	if toks, err := Lex(src); err == nil {
		for _, t := range toks {
			if strings.Contains(t.Text, "\n") {
				spans = append(spans, [2]int{t.Start, t.End})
			}
		}
	} else {
		return src
	}
	inside := func(off int) bool {
		for _, s := range spans {
			if off > s[0] && off < s[1] {
				return true
			}
		}
		return false
	}
	lines := make([]int, 0, len(comments))
	for l := range comments {
		if l >= 1 && l < len(lineStart) {
			lines = append(lines, l)
		}
	}
	sort.Ints(lines)
	var sb strings.Builder
	last := 0
	for _, l := range lines {
		off := lineStart[l]
		if inside(off) {
			continue
		}
		text := sanitizeComment(comments[l])
		if text == "" {
			continue
		}
		end := off
		for end < len(src) && (src[end] == ' ' || src[end] == '\t') {
			end++
		}
		sb.WriteString(src[last:off])
		sb.WriteString(src[off:end])
		sb.WriteString("-- ")
		sb.WriteString(text)
		sb.WriteString("\n")
		last = off
	}
	sb.WriteString(src[last:])
	return sb.String()
}

func sanitizeComment(s string) string {
	s = strings.Join(strings.Fields(s), " ")
	s = strings.TrimSpace(strings.TrimPrefix(s, "--"))
	if len(s) > 240 {
		s = s[:240] + "..."
	}
	return s
}

// CompactBlankLines collapses runs of 2+ consecutive blank lines into at most
// one blank line, skipping any newlines inside multi-line string or comment
// tokens so literal contents are never altered.
func CompactBlankLines(src string) string {
	toks, err := Lex(src)
	if err != nil {
		return src
	}
	var spans [][2]int
	for _, t := range toks {
		if strings.Contains(t.Text, "\n") {
			spans = append(spans, [2]int{t.Start, t.End})
		}
	}
	inSpan := func(off int) bool {
		lo, hi := 0, len(spans)
		for lo < hi {
			mid := (lo + hi) >> 1
			if spans[mid][1] <= off {
				lo = mid + 1
			} else {
				hi = mid
			}
		}
		return lo < len(spans) && off > spans[lo][0] && off < spans[lo][1]
	}

	var sb strings.Builder
	sb.Grow(len(src))
	blankRun := 0
	lineStart := 0
	for i := 0; i <= len(src); i++ {
		if i < len(src) && src[i] != '\n' {
			continue
		}
		line := src[lineStart:i]
		hasNewline := i < len(src)
		protected := inSpan(lineStart) || (hasNewline && inSpan(i))
		isBlank := !protected && strings.Trim(line, " \t\r") == ""
		if isBlank {
			blankRun++
			if blankRun <= 1 {
				if hasNewline {
					sb.WriteByte('\n')
				}
			}
		} else {
			blankRun = 0
			sb.WriteString(line)
			if hasNewline {
				sb.WriteByte('\n')
			}
		}
		lineStart = i + 1
	}
	return sb.String()
}

// TidyFormatting performs lexer-safe Luau syntax tidying without altering
// string literals, comments, or evaluation semantics:
//   - Simplifies `not (a.b)` -> `not a.b` when not followed by suffix ops
//   - Simplifies `for k, v in next, tbl, nil do` -> `for k, v in next, tbl do`
func TidyFormatting(src string) string {
	all, err := Lex(src)
	if err != nil {
		return src
	}
	var toks []Token
	for _, t := range all {
		if t.Kind != Comment {
			toks = append(toks, t)
		}
	}
	type span struct{ start, end int }
	var drops []span

	isSuffixStart := func(t Token) bool {
		if t.Kind == String {
			return true
		}
		if t.Kind == Op {
			switch t.Text {
			case ".", ":", "[", "(", "{":
				return true
			}
		}
		return false
	}

	for i := 0; i < len(toks); i++ {
		// Pattern 1: `not ( ident(.ident)* )` not followed by suffix op
		if toks[i].Kind == Keyword && toks[i].Text == "not" &&
			i+3 < len(toks) && toks[i+1].Kind == Op && toks[i+1].Text == "(" &&
			toks[i+2].Kind == Name {
			j := i + 3
			for j+1 < len(toks) && toks[j].Kind == Op && toks[j].Text == "." && toks[j+1].Kind == Name {
				j += 2
			}
			if j < len(toks) && toks[j].Kind == Op && toks[j].Text == ")" {
				if j+1 >= len(toks) || !isSuffixStart(toks[j+1]) {
					// Ensure a space remains between `not` and the identifier if `not(` had none
					if toks[i].End == toks[i+1].Start {
						// leave `not(` alone or replace `(` with ` `; easiest: skip rare `not(x)` without space
					} else {
						drops = append(drops, span{toks[i+1].Start, toks[i+1].End})
						drops = append(drops, span{toks[j].Start, toks[j].End})
						i = j
						continue
					}
				}
			}
		}
		// Pattern 2: `in next , <ident(.ident)*> , nil do` -> drop `, nil`
		if toks[i].Kind == Keyword && toks[i].Text == "in" &&
			i+5 < len(toks) && toks[i+1].Kind == Name && toks[i+1].Text == "next" &&
			toks[i+2].Kind == Op && toks[i+2].Text == "," && toks[i+3].Kind == Name {
			j := i + 4
			for j+1 < len(toks) && toks[j].Kind == Op && toks[j].Text == "." && toks[j+1].Kind == Name {
				j += 2
			}
			if j+2 < len(toks) && toks[j].Kind == Op && toks[j].Text == "," &&
				toks[j+1].Kind == Keyword && toks[j+1].Text == "nil" &&
				toks[j+2].Kind == Keyword && toks[j+2].Text == "do" {
				drops = append(drops, span{toks[j].Start, toks[j+1].End})
				i = j + 1
			}
		}
	}

	if len(drops) == 0 {
		return src
	}
	sort.Slice(drops, func(i, j int) bool { return drops[i].start < drops[j].start })
	var sb strings.Builder
	sb.Grow(len(src))
	last := 0
	for _, d := range drops {
		if d.start < last {
			continue
		}
		sb.WriteString(src[last:d.start])
		last = d.end
	}
	sb.WriteString(src[last:])
	return sb.String()
}

