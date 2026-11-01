# Audit report -- P4 callee-slot fix (HEAD `678ff63`, tag withheld)

Status: **audit passed, tagged** -- `v0.5-p4-callee-slot` was created on
`6c45797` after the independent audit reproduced every number below. Section 9
records the two bookkeeping corrections the audit asked for, section 8 the two
deviations it ruled on.

What changed, in one sentence: writes to a jump/cff register that a surviving
statement **calls through** are no longer dropped, so a call whose callee the
lifter had erased no longer prints as `(nil)(...)`.

Reproduce (every number below comes from these four commands):

```
node deob.js samples/input/Luraph/SampleV1.lua -o /tmp/new.lua     # SampleV1, ~180 s
node deob.js /tmp/refs/RideAPet_in.lua    -o /tmp/pet.lua          # differential, ~40 s
node deob.js /tmp/refs/StealAnEgg_in.lua  -o /tmp/egg.lua          # differential, ~140 s
python3 scripts/metrics.py /tmp/new.lua
```

`/tmp/f1.lua` and `/tmp/d2_old.lua` are the pre-fix (`1e0d1eb`) outputs, produced
from a separate `git worktree` of that commit.

---

## 1. The 55 `residual_unknown` sites: classification and decision

Method (env-gated probe, read-only, **output byte-identical with it on**, reverted
afterwards): every `variables.rename` site that resolves to `Const(None)` is
recorded with its proto (lift sequence, `pid`, depth), register and block; for the
same proto the walked IR is scanned for `Assign` targeting that register (split by
the `jump` flag), plus the proto's `frame_uses` and its count of
`unexplored successor` blocks. `CallStmt` results live in temps, not registers, so
an `Assign` scan does cover register writes.

39 distinct `(proto, register)` pairs, 55 read sites:

| register | location | read sites | category | evidence |
|---|---|---|---|---|
| `r101` | pid 32, depth 0 | 1 | 3 -- caller value | no `Assign` to `r101` in 926 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r4` | lift 105 (unnamed), depth 1 | 1 | 3 -- header/return only | 5 write(s), none reaching; recorded def sits in a condition header or `ret` block; 0 unexplored successors; `frame_uses` empty |
| `r14` | lift 105 (unnamed), depth 1 | 1 | 3 -- caller value | no `Assign` to `r14` in 82 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r21` | pid 40, depth 1 | 1 | 3 -- caller value | no `Assign` to `r21` in 61 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r40` | lift 13 (unnamed), depth 5 | 1 | 3 -- caller value | no `Assign` to `r40` in 47 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r102` | lift 13 (unnamed), depth 5 | 1 | 3 -- caller value | no `Assign` to `r102` in 47 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r106` | lift 13 (unnamed), depth 5 | 1 | 3 -- caller value | no `Assign` to `r106` in 47 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r111` | lift 13 (unnamed), depth 5 | 1 | 3 -- caller value | no `Assign` to `r111` in 47 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r18` | lift 2 (unnamed), depth 2 | 1 | 3 -- caller value | no `Assign` to `r18` in 171 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r9` | lift 20 (unnamed), depth 1 | 2 | 3 -- caller value | no `Assign` to `r9` in 561 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r27` | lift 21 (unnamed), depth 1 | 3 | 3 -- caller value | no `Assign` to `r27` in 44 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r15` | lift 23 (unnamed), depth 1 | 1 | 3 -- caller value | no `Assign` to `r15` in 22 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r11` | lift 25 (unnamed), depth 1 | 1 | 3 -- caller value | no `Assign` to `r11` in 26 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r25` | lift 34 (unnamed), depth 1 | 1 | 3 -- caller value | no `Assign` to `r25` in 19 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r38` | lift 34 (unnamed), depth 1 | 1 | 3 -- caller value | no `Assign` to `r38` in 19 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r10` | lift 36 (unnamed), depth 1 | 1 | 3 -- caller value | no `Assign` to `r10` in 30 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r6` | lift 38 (unnamed), depth 1 | 1 | 3 -- header/return only | 8 write(s), none reaching; recorded def sits in a condition header or `ret` block; 0 unexplored successors; `frame_uses` empty |
| `r9` | lift 38 (unnamed), depth 1 | 1 | 3 -- header/return only | 5 write(s), none reaching; recorded def sits in a condition header or `ret` block; 0 unexplored successors; `frame_uses` empty |
| `r12` | lift 38 (unnamed), depth 1 | 1 | 3 -- header/return only | 3 write(s), none reaching; recorded def sits in a condition header or `ret` block; 0 unexplored successors; `frame_uses` empty |
| `r14` | lift 38 (unnamed), depth 1 | 1 | 3 -- header/return only | 4 write(s), none reaching; recorded def sits in a condition header or `ret` block; 0 unexplored successors; `frame_uses` empty |
| `r85` | lift 38 (unnamed), depth 1 | 1 | 3 -- caller value | no `Assign` to `r85` in 216 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r104` | lift 38 (unnamed), depth 1 | 2 | 3 -- caller value | no `Assign` to `r104` in 216 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r9` | lift 39 (unnamed), depth 1 | 1 | 3 -- header/return only | 1 write(s), none reaching; recorded def sits in a condition header or `ret` block; 0 unexplored successors; `frame_uses` empty |
| `r39` | lift 40 (unnamed), depth 1 | 1 | 3 -- caller value | no `Assign` to `r39` in 40 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r9` | lift 41 (unnamed), depth 1 | 1 | 3 -- header/return only | 2 write(s), none reaching; recorded def sits in a condition header or `ret` block; 0 unexplored successors; `frame_uses` empty |
| `r25` | lift 43 (unnamed), depth 1 | 1 | 3 -- caller value | no `Assign` to `r25` in 118 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r17` | lift 46 (unnamed), depth 1 | 1 | 3 -- caller value | no `Assign` to `r17` in 36 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r11` | lift 47 (unnamed), depth 1 | 2 | 3 -- caller value | no `Assign` to `r11` in 63 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r32` | lift 47 (unnamed), depth 1 | 1 | 3 -- caller value | no `Assign` to `r32` in 63 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r7` | lift 59 (unnamed), depth 1 | 1 | 3 -- caller value | no `Assign` to `r7` in 49 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r24` | lift 60 (unnamed), depth 1 | 1 | 3 -- caller value | no `Assign` to `r24` in 54 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r8` | lift 63 (unnamed), depth 1 | 2 | 3 -- caller value | no `Assign` to `r8` in 91 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r9` | lift 63 (unnamed), depth 1 | 1 | 3 -- caller value | no `Assign` to `r9` in 91 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r20` | lift 63 (unnamed), depth 1 | 2 | 3 -- caller value | no `Assign` to `r20` in 91 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r19` | lift 64 (unnamed), depth 1 | 9 | 3 -- caller value | no `Assign` to `r19` in 181 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r7` | lift 70 (unnamed), depth 1 | 1 | 3 -- header/return only | 2 write(s), none reaching; recorded def sits in a condition header or `ret` block; 0 unexplored successors; `frame_uses` empty |
| `r16` | lift 79 (unnamed), depth 2 | 1 | 3 -- caller value | no `Assign` to `r16` in 171 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r13` | lift 86 (unnamed), depth 1 | 2 | 3 -- caller value | no `Assign` to `r13` in 61 walked blocks; 0 unexplored successors; `frame_uses` empty |
| `r8` | pid 39, depth 1 | 1 | 3 -- caller value | no `Assign` to `r8` in 17 walked blocks; 0 unexplored successors; `frame_uses` empty |

Aggregates: 31 pairs / 47 sites read a register the walked IR never writes;
8 pairs / 8 sites have writes but none reaches (the recorded def sits in a
condition header or a `ret` block); `jump` writes **0**; `unexplored successor`
**0** in all 39 protos; `frame_uses` empty in all 39; depth 46 sites at 1, 2 at 2,
4 at 5, 1 at 0.

**Decision -- close as measured, no code.** No site is a frame-upvalue read (cases
1 and 2 of the shared-frame plan have zero instances), none is jump-flagged (not
the callee class), and nothing was pruned (nothing to restore). Every one is the
hard boundary: a value the trace never produced. The shared-frame propagation is
therefore not implemented -- a mechanism with zero instances and no test on this
corpus would be dead code.

Permanent evidence lines, printed by every full lift:

```
[*]   frame_propagation: bound=0 residual_unknown=55     (SampleV1)
[*]   frame_propagation: bound=0 residual_unknown=116    (StealAnEgg)
```

`residual_unknown` counts reads for which `variables.rename` found no name at all,
over every lifted proto (so before dead-code removal); it is not the count of
visible `(nil)(...)` uses. Both counters live in `variables.LIFT_STATS`, are reset
per lift and are deterministic. Recorded in `TECHNICAL.md` section 10.

---

## 2. SampleV1 raw metrics

`python3 scripts/metrics.py /tmp/new.lua`:

```
lines                    43836
bytes                    1492727
parses                   True
devirt_errors            0
devirt_errors_by_message 0
devirt_comments          10
devirt_comments_by_message {'devirt: spin loop left out (its body has no effect: its only statement wrote a value nothing reads)': 10}
unresolved_uses          185
unresolved_distinct      21
unresolved_hints         158
unresolved_unhinted      0
bit32_calls              49
bxor_calls               16
bit32_lines              35
bit32_chain_lines        14
bit32_chain_calls        20
empty_while_true         0
blank_lines              4742
```

Before -> after:

| metric | v0.4 (`1e0d1eb`) | now (`678ff63`) |
|---|---|---|
| lines | 43,820 | 43,836 |
| bytes | 1,492,328 | 1,492,727 |
| parses | True | True |
| `devirt_errors` | 0 | 0 |
| `devirt_comments` | 10 | 10 (same message) |
| `unresolved_uses` / `distinct` / `hints` / `unhinted` | 185 / 21 / 158 / 0 | 185 / 21 / 158 / 0 |
| `bit32_calls` | 50 | **49** (2.2) |
| `bit32_chain_lines` / `chain_calls` | 17 / 25 | **14 / 20** (2.1) |
| `bxor_calls` | 15 | 16 |
| `bit32_lines` | 35 | 35 |
| `empty_while_true` | 0 | 0 |
| `blank_lines` | 4,739 | 4,742 |

Spin markers (10, unchanged message) at lines 8397, 8399, 8430, 8548, 9924,
11761, 15337, 17001, 43256, 43829. The watermark comment `-- This Source Was
Generated by discord.gg/c3xVMnUUBv` moves 43213 -> 2136 (cosmetic, same text, now
indented); `print("Deobf By Zed")` moves 43820 -> 43836 with the file end.

### 2.1 Why `bit32_chain_lines` went 17 -> 14

`scripts/metrics.py` counts a chain as a run of **at least three consecutive**
statements that each hold a `bit32` call. The four runs counted as 17 were:
line 35508 (5 lines), 43493 (3), 43543 (3), 43550 (6). After the fix: 35509 (5),
43516 (3), 43572 (6) = 14. The run that vanished is the 3-line / 5-call prefix of
the cipher in `callback10`:

```
local value10 = bit32.band(bit32.rshift(nil, 29), 7)
local value11 = bit32.band(bit32.bxor(nil, value10), 536870911)
local value12 = bit32.bxor(146907180, value11)
```

`./bin/luau` on the first returns `invalid argument #1 to 'rshift' (number
expected, got nil)`, so those three lines were never the script's code -- they were
a permanently broken hole. With the callee register materialised the same value is
one line of real arithmetic (`local number15 = 3972087808`,
`local value5 = bit32.band(bit32.bxor(526889733, number15), 536870911)`), the run
is shorter than three, and 3 chain lines / 5 chain calls leave the count. The fold
then sees 8 repetitions instead of 9 (the 9th was the phase-shifted remainder of
the broken prefix). Verified honest:
`python3 scripts/bitfold_verify.py --before <nofold> --after <fold>` ->
`PASS identical on 512 random inputs (1 chain folded)`.

The gates "`bit32_chain_lines` 17" and "nil `bit32` operands 0" cannot both hold:
the 17 existed only because the operand was `nil`. Amended gate: 14.

### 2.2 `bit32_calls` per operation, 50 -> 49

| op | v0.4 | now |
|---|---|---|
| `band` | 15 | 14 |
| `bnot` | 1 | 1 |
| `bor` | 0 | 0 |
| `bxor` | 15 | 16 |
| `lshift` | 6 | 6 |
| `rshift` | 13 | 12 |
| **total** | **50** | **49** |

Exact arithmetic: the three vanished prefix lines held 5 calls (`band`x2,
`rshift`x1, `bxor`x2); the replacing prefix holds 2 (`band`x1, `bxor`x1); two
`x = bit32.bxor(x, ...)` stores that used to be erased with the callee slot are
now visible (+2 `bxor`). 50 - 5 + 2 + 2 = 49.

The one call that is **not** conserved is a `bit32.bor(1171037852, ...)` store. The
wider variant (every register a surviving expression *reads*) restores it and lands
on exactly 50, but it also restores four neighbouring bookkeeping statements
(`local number17 = 1889749313`, `number17 = 1889749313`,
`local number18 = 259159099`, `number18 = 78971088`). This build takes only the
callee slot, per the scope decision, so the `bor` store stays dropped and the total
is 49. This is the one place where the report does not meet the original "total
50" wording -- see 8.A.

---

## 3. `nil` census

| | v0.4 | now |
|---|---|---|
| `(nil)(...)` call sites | 7 | **1** |
| `bit32` calls with a `nil` operand | 2 | **0** |

The seven v0.4 sites, all in `callback10`:

```
43529  local value6 = (nil)(argument[1] or argument.r)
43530  local value7 = (nil)(argument[2] or argument.g)
43531  local value8 = (nil)(argument[3] or argument.b)
43537  return (nil)(value6, value7, value8)
43539  math.floor((nil)(value6, 0, 255, 0))
43541  local value9 = table.pack((nil)(value7, 0, 255, 0))
43563  return (nil)(nil, nil)
```

Six of them become `tonumber`, `Color3.new`, `callback4(...)` x3 (block diff in
4.1). The seventh, `return (nil)(nil, nil)` (now line 43579), **remains**: callee
and both arguments are registers with no write anywhere in the traced function,
i.e. one of the 47 case-3 sites of section 1. Reaching 0 there would require
inventing a callee, so 1 is the floor under the project rule "unknown caller
values stay plain `nil`". Second deviation from the original gate wording -- see
8.B.

The two `nil` `bit32` operands (v0.4 lines 43543-43544) are gone (0).

---

## 4. Diffs

### 4.1 SampleV1 -- the merged cipher block (the 17 -> 14 story)

```
@@ -43522,31 +43540,29 @@
 	VerticalAlignment = Enum.VerticalAlignment,
 }
 
-local function callback10(argument)
-	if nil ~= "table" then
+local function callback11(argument)
+	if type(argument) ~= "table" then
 		return nil
 	end
-	local value6 = (nil)(argument[1] or argument.r)
-	local value7 = (nil)(argument[2] or argument.g)
-	local value8 = (nil)(argument[3] or argument.b)
-
-	if value6 then
-		if value7 then
-			if value8 then
-				if value6 <= 1 and value7 <= 1 and value8 <= 1 then
-					return (nil)(value6, value7, value8)
-				end
-				math.floor((nil)(value6, 0, 255, 0))
-				local floor = math.floor
-				local value9 = table.pack((nil)(value7, 0, 255, 0))
-				floor(table.unpack(value9, 1, value9.n))
-				local value10 = bit32.band(bit32.rshift(nil, 29), 7)
-				local value11 = bit32.band(bit32.bxor(nil, value10), 536870911)
-				local value12 = bit32.bxor(146907180, value11)
+	local number13 = tonumber(argument[1] or argument.r)
+	local value = tonumber
+	local value4 = value(argument[2] or argument.g)
+	local number14 = tonumber(argument[3] or argument.b)
+
+	if number13 then
+		if value4 then
+			if number14 then
+				if number13 <= 1 and value4 <= 1 and number14 <= 1 then
+					return Color3.new(number13, value4, number14)
+				end
+				math.floor(callback4(number13, 0, 255, 0))
+				math.floor(callback4(value4, 0, 255, 0))
+				local number15 = 3972087808
+				local value5 = bit32.band(bit32.bxor(526889733, number15), 536870911)
 
-				-- folded: 9 repetitions of a 6-statement bit32 chain
+				-- folded: 8 repetitions of a 6-statement bit32 chain
 				local function mixBits(argument2)
-					for _ = 1, 9 do
+					for _ = 1, 8 do
 						local argument3 = bit32.lshift(argument2, 13)
 						local argument4 = bit32.band(bit32.bxor(argument2, argument3), 536870911)
 						local argument5 = bit32.rshift(argument4, 13)
```

### 4.2 SampleV1 -- hunk inventory, 22 hunks, 87 removed / 103 added

Categories: `C` = cosmetic (watermark relocation), `N` = local renumbering caused
by the new `callback4` body and its globals taking names, `F` = nil-to-name fix,
`R` = restored statement, `S` = the merged cipher prefix of 2.1.

| # | hunk | category | first removed -> first added |
|---|---|---|---|
| 1 | `@@ -2133,6 +2133,7 @@` | C | watermark appears, indented |
| 2 | `@@ -43209,8 +43210,24 @@` | F/R | `callback4` becomes a real top-level function (`local number7 = 155558815`) |
| 3 | `@@ -43234,26 +43251,26 @@` | N | `local callback4, value2, value3` -> `local callback5` |
| 4 | `@@ -43274,9 +43291,9 @@` | R | `number7 = bit32.bxor(number7, 3136058929)` visible |
| 5 | `@@ -43313,9 +43330,9 @@` | N | `number7 = 454389566` -> `number8` |
| 6 | `@@ -43334,7 +43351,7 @@` | N | `local number8 = ...` -> `number9` |
| 7 | `@@ -43381,13 +43398,13 @@` | N | `callback7` -> `callback8` |
| 8 | `@@ -43395,7 +43412,7 @@` | N | `callback8` -> `callback9` |
| 9 | `@@ -43411,27 +43428,27 @@` | N | `callback9` -> `callback10` |
| 10 | `@@ -43444,10 +43461,10 @@` | N | `return number10, false` -> `number11` |
| 11 | `@@ -43490,9 +43507,9 @@` | N | `number10` -> `number11` |
| 12 | `@@ -43506,7 +43523,8 @@` | R | `x = bit32.bxor(number7, 76579608)` visible |
| 13 | `@@ -43522,31 +43540,29 @@` | F/S | the cipher block of 4.1 |
| 14 | `@@ -43558,8 +43574,8 @@` | N | `mixBits(value12)` -> `mixBits(value5)` |
| 15 | `@@ -43573,9 +43589,9 @@` | N | `number12` -> `number13` |
| 16 | `@@ -43619,27 +43635,27 @@` | N | `local value6` -> `local value4` |
| 17 | `@@ -43663,13 +43679,13 @@` | N | `callback6` -> `callback7` |
| 18 | `@@ -43681,10 +43697,10 @@` | N | `value6, value7, value8` -> `value4, value5, value6` |
| 19 | `@@ -43701,7 +43717,7 @@` | N | `callback12()` -> `callback13()` |
| 20 | `@@ -43779,19 +43795,19 @@` | N | `number13` -> `number14` |
| 21 | `@@ -43802,8 +43818,8 @@` | N | `bit32.bxor(number13, ...)` -> `number14` |
| 22 | `@@ -43814,7 +43830,7 @@` | N | `number13 = 154216614` -> `number14` |

Every hunk is one of: the watermark moving, a name shifting because a new global
exists, a statement whose writes were dropped only because the register is a call
target, or the cipher prefix of 2.1. No hunk of any other kind exists. The
per-line ledger that sums to 87/103 is in section 9.

### 4.3 StealAnEgg -- the restored WebSocket block (12 statements)

```
@@ -50150,43 +50150,51 @@
 	if bit32.bxor(number7, 398250199) ~= 248919854 then
 		number7 = bit32.bxor(number7, 2079730401)
 	end
-	local value2, value3 = callback17(match)
-	if not value2 then
+	local value, value2 = callback17(match)
+	if not value then
 		if match == "" then
 			return { deleted = false, reason = "managed UI does not exist" }
 		end
-		error(value3)
+		error(value2)
 	end
 	disconnectAll(connections2)
-	local value4 = callback8(value2)
-	value2:Destroy()
-	return { deleted = true, path = value4 }
+	local value3 = callback8(value)
+	value:Destroy()
+	return { deleted = true, path = value3 }
 end
 
 number7 = 426436601
-local value2, value3, value4
+local value, value2, value3
 
 local function callback21()
-	local value5, value6 = (nil)()
-	if nil then
+	local value4, value5 = callback5()
+	if not value4 then
+		callback4("No supported WebSocket API found")
 		return false
 	end
-	number4 = nil
+	number4 += 1
+	callback3("Connecting to", "wss://chillihub.pro/roblox-mcp?token=chp-7E0Yzx4yddoAozc9VNLsqTnA", "using", value5)
 	local number8 = 409832479
 	local function callback22()
 		if number8 ~= 526742413 then
 			number8 = bit32.bxor(number8, 607761351)
 		end
-		return value5("wss://chillihub.pro/roblox-mcp?token=chp-7E0Yzx4yddoAozc9VNLsqTnA")
+		return value4("wss://chillihub.pro/roblox-mcp?token=chp-7E0Yzx4yddoAozc9VNLsqTnA")
 	end
 	number8 = 526742413
-	local value7 = table.pack((nil)(callback22))[2]
-	if nil and value7 then
-		value = value7
+	local ok, response = pcall(callback22)
+
+	if ok and response then
+		response3 = response
 		condition4 = true
+		callback6(response3, "OnMessage", "MessageReceived")
+		callback6(response3, "OnClose", "Closed", "OnDisconnect")
+		local callback = callback6
+		callback(response3, "OnError", "Error")
 		-- devirt: spin loop left out (it decoded to no statements)
 	end
-	callback4("Connection failed:", (nil)(value7))
+
+	callback4("Connection failed:", tostring(response))
 	return false
 end
```

### 4.4 StealAnEgg -- hunk inventory, 25 hunks, 102 removed / 110 added

Normalised comparison (identifiers and numeric literals erased, watermark comment
counted separately): 95 of the removed lines differ from an added line only in
local names. Substantive rest: 6 removed, 12 added, 0 removed / 2 added blank
lines -- all inside hunk 21 above. Hunks 1-2 are the watermark comment (line 4 ->
line 3229); hunks 3-20 and 22-25 are the `value`/`response3` renumbering that
follows, because `local value = nil` became `local response3 = nil` and frees the
word `value` for the whole scope. Ledger: 102 removed = 1 watermark + 95
renumbering + 6 substantive; 110 added = 1 watermark + 2 blank + 95 renumbering +
12 substantive.

The narrowed build and the wide build are **byte-identical** on this input
(`cmp`), because every statement restored here is itself a write to the callee
slot: the run prints a single `[jread] proto=<tid> depth=1 kept=19 regs=[2]`.

---

## 5. StealAnEgg conservation

Anchor census, old vs new (every anchor the block touches gains exactly one, none
is lost):

| anchor | old | new |
|---|---|---|
| `wss://` | 2 | 3 |
| `chillihub.pro` | 23 | 24 |
| `roblox-mcp` | 5 | 6 |
| `OnMessage` | 1 | 2 |
| `OnClose` | 1 | 2 |
| `OnError` | 0 | 1 |
| `WebSocket` | 21 | 22 |
| `pcall(` | 520 | 521 |
| `gethui` | 19 | 19 |
| `ChilliCanvasHold` | 2 | 2 |
| `discord.gg/c3xVMnUUBv` | 1 | 1 |
| `Deobf By Zed` | 1 | 1 |
| `local function` | 1060 | 1060 |
| `while true do` | 71 | 71 |

Other checks:

- `parses` True on both sides (`scripts/metrics.py`); `./bin/luau-ast` exit 0 on
  both.
- `devirt_errors` 0 on both; `devirt_comments` 4 on both (same messages).
- `unresolved_uses` / `hints` / `unhinted`: 0 / 0 / 0 on both.
- `bit32` metrics identical: 74 calls, 54 `bxor`, 66 `bit32` lines, chain 5 / 6.
- lines 50,393 -> 50,401; blank lines 5,610 -> 5,612.
- Two runs of the new build: `cmp` byte-identical.
- `node --test`: 30 pass / 2 fail / 19 skipped -- **identical to a clean checkout
  of `1e0d1eb`** (the two failures, `input/ subfolder ...` and `renamer ...`,
  reproduce there without this change), so no new failure.

---

## 6. RideAPet

Differential status: **no restoration, no change at all.** The new build's output
is byte-identical (`cmp`) to the `1e0d1eb` output on that input. The fix does not
fire there -- no `[jread]` line -- and the `frame_propagation` line prints the same
counters. Stated both ways: old -> new changes nothing, new -> old changes nothing.

---

## 7. Gate rules, rewritten deterministically

A diff on a sample is allowed only if **every** changed line falls into one of
these categories, and every instance is enumerated in the report:

1. **Cosmetic** -- a comment or blank line moving (watermark, markers): same text,
   different line number, indentation may change.
2. **Renumbering** -- a local's name changes because a name earlier in the same
   scope was taken or freed. Identifier-only: the line with identifiers and
   numeric literals erased must match another changed line exactly.
3. **nil -> name** -- a `nil` operand or a `(nil)(...)` callee replaced by a name
   that was already in scope (`variables.rename`'s `Const(None)` sink).
4. **Restored statement** -- a statement that was dropped only because its target
   register is a call target (its writes were `jump`-flagged), enumerated one by
   one with anchor conservation on the same sample.

Any diff outside 1-4 stops the milestone and is reported instead of merged.
Category 4 additionally requires: anchor census before/after, `parses` True,
`luau-ast` exit 0, two runs byte-identical, and `node --test` with no new failure
relative to a clean checkout of the parent commit.

Applied here: SampleV1 = 1xC + 18xN + 1xF/S + 2xR hunks; StealAnEgg = 2xC + 22xN
+ 1 hunk mixing 6xF/S with 12xR (enumerated in 4.3); RideAPet = no hunks.

---

## 8. Open items for the audit

Two places where the result does not match the original gate wording. Both are
measurement outcomes, not implementation failures, and both were **ruled on** by
the audit (decision quoted in each item):

**A. `bit32_calls` 50 -> 49 (gate wording asked for 50 conserved).** Conserving 50
requires also restoring one `bit32.bor(1171037852, ...)` store plus the four
bookkeeping statements next to it, i.e. the wide variant (2.2). Options: accept 49
with the callee-only scope, or return to the wide variant and accept the five
restored bookkeeping statements. The choice changes SampleV1 only (one line, one
call); StealAnEgg and RideAPet are unaffected.

*Audit decision: accept 49.* The old 50 is not an honest baseline -- it counts
five calls inside the permanently broken `nil`-operand prefix. The per-operation
baseline from this milestone on is **band 14, bnot 1, bor 0, bxor 16, lshift 6,
rshift 12 = 49**. The wide variant (`bor` + four bookkeeping statements) is an
*optional* P5 candidate under the same evidence pattern, not a gate item.

**B. `(nil)(...)` 7 -> 1 (gate wording asked for 0).** The remaining site is
`return (nil)(nil, nil)`: callee and both arguments unwritten in the traced
function, one of the 47 case-3 sites classified in section 1. Reaching 0 would
require inventing a callee value, which the project rules forbid.

*Audit decision: accept 1.* The gate from this milestone on is
**`(nil)(...)` <= 1, and only at the documented site (line 43579 of
`samples/output/Luraph/SampleV1.lua`)**. Any new site -- or that site moving to a
different construct -- stops the run and is reported.

---

## 9. Bookkeeping reconciliation (audit note 1)

The hunk inventory in 4.2 first reported "84 removed / 98 added". The raw diff of
the two **committed** outputs is larger, and the authoritative figure is git's own
count:

```
git diff --numstat 1e0d1eb 678ff63 -- samples/output/Luraph/SampleV1.lua
103     87      samples/output/Luraph/SampleV1.lua
```

so 87 removed / 103 added, 22 hunks. The 84/98 came from counting with
`grep -c '^-[^-]'` / `grep -c '^+[^+]'`, a filter that silently drops two kinds of
changed line: (a) a line whose *content* starts with `-` or `+` -- here exactly the
moved watermark comment `-- This Source Was Generated by discord.gg/c3xVMnUUBv`,
which renders as `--- This Source ...` on the removed side; and (b) a **blank**
changed line, which renders as a bare `-` or `+` with no second character. That is
84 + 1 comment + 2 blank = 87 and 98 + 1 comment + 5 blank = 103. A figure of
86/102 is the same artefact one blank pair short of the numstat; nothing
substantive is missing from either count.

Ledger with every line in exactly one bucket (watermark separated first, then
blank, then identifier-only twins, rest substantive):

| sample | removed | watermark | blank | renumbering twins | substantive |
|---|---|---|---|---|---|
| SampleV1 | 87 | 1 | 2 | 71 | 13 |
| SampleV1 (added) | 103 | 1 | 5 | 71 | 26 |
| StealAnEgg | 102 | 1 | 0 | 95 | 6 |
| StealAnEgg (added) | 110 | 1 | 2 | 95 | 12 |

The 13 removed / 26 added substantive `SampleV1` lines are exactly the two things
4.1 and 4.2 describe: the nine-line `callback4` body becoming a real top-level
function (`local number7 = 155558815`, `local function callback4(...)`,
`local number8 = tonumber(argument)`, `if number8 then`, `local max = math.max`,
`local value2 = table.pack(math.min(...))`, `if number7 ~= 49270517 then`,
`return max(...)`, `return argument4`), its forward declaration changing from
`local callback4, value2, value3` to `local callback5`, the `type(argument)` guard,
the three `tonumber`/`Color3.new`/`callback4` call sites, the two
`x = bit32.bxor(x, ...)` stores that were being erased with the callee slot, two
`local number15 = 278712415` / `278712415` style constants, and the merged cipher
prefix. Every one is enumerated above; none is unexplained.

The `StealAnEgg` ledger (6 / 12) is the block in 4.3, item by item.

From here on every report states its line counts with the command that produced
them, and any count of changed lines is the git numstat (or the same method,
`---`/`+++` headers and the file header excluded, blanks included).
