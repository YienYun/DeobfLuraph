# Layer-2 Luau Renamer, Dead-Code Cleaner & Smart Commenter (`renamer/`)

Folder ini adalah **Layer 2** pasca-deobfuscation / pasca-decompile untuk mengubah output Luau/Lua hasil deobfuscator (maupun hasil `decompile()` executor seperti Konstant, Medal, Oracle, dll.) menjadi source code yang bersih, bebas sampah, memiliki nama variabel/fungsi bermakna, serta dilengkapi komentar penjelasan otomatis **tanpa merusak logika runtime**.

## Mesin Open-Source yang Digunakan

Sesuai prinsip *zero fragile regex*, sistem ini dibangun langsung di atas **3 fondasi open-source resmi**:

1. **[`seaofvoices/darklua`](https://github.com/seaofvoices/darklua)** (`renamer/vendor/darklua`, MIT License — Rust/WASM Luau AST Compiler)
   - Menghapus kode mati & menyederhanakan ekspresi secara sah di level AST Luau (`compute_expression`, `convert_index_to_field`, `filter_after_early_return`, `remove_empty_do`, `remove_unused_if_branch`, `remove_unused_variable`, `remove_unused_while`).
   - `remove_unused_variable` otomatis dilewati kalau file punya deklarasi `local a, b` tanpa initializer: versi darklua ini menghapus **seluruh** statement saat salah satu nama tidak terpakai, sehingga `a = ...` berubah jadi penulisan global. Deklarasinya dibiarkan utuh dan alasannya muncul di `warnings`.
2. **[`officialmelon/BetterDecompiler` v2.0.0](https://github.com/officialmelon/BetterDecompiler)** (`renamer/vendor/betterdecompiler` -> `renamer/bin/betterdecompiler`)
   - Lexer + Scope-Resolving Luau Parser + **Verified Renamer (`sameResolution`)**: setiap perubahan nama variabel di-parse ulang dan diverifikasi bahwa 100% referensi token tetap menunjuk ke binding yang persis sama (mustahil terjadi *variable shadowing* atau perubahan perilaku!).
   - Diperluas khusus untuk mengenali pola variabel/fungsi DeobfLuraph, API Roblox & Executor (`getgenv`, `gethui`, `readfile`, `writefile`, `request`, `WebSocket`, `Drawing`, `fireproximityprompt`, dll.), serta **Smart Contextual Commenter** (offline instan maupun berbasis AI LLM).
3. **Official Roblox Luau AST (`./bin/luau-ast`) + Deobf Chaff Polisher (`engine/ast_polish.py`)**
   - Menyapu sisa artefak VM Luraph (argumen dummy state-key, cabang *opaque predicate* konstan, rantai `bit32`/`table.pack` mati, IIFE pembungkus) dan memvalidasi sintaks Luau akhir.

---

## Cara Pakai

### 1. Sekali Jalan Bersama Deobfuscator (`deob.js --rename`)
Jalankan Layer 1 (Devirtualizer Luraph v15.0/v15.1) + Layer 2 (Garbage Cleaner + Verified Renamer + Smart Comments) sekaligus dalam **satu perintah**:

```bash
node deob.js protected.lua -o renamed.lua --rename
```

`--rename` berlaku untuk hasil `devirtualized` maupun `payload-source` (skrip yang
diprint dari carrier), jadi satu perintah menghasilkan file yang sudah dinamai.

Opsi tambahan pada `deob.js`:
- `--comments light` *(default)* | `--comments detailed` | `--comments none`
- `--ai-provider <openai|gemini|anthropic|groq|deepseek|openrouter|xai|ollama|lmstudio>`
- `--ai-model <model-name>`

### 2. Mandiri (Standalone Layer 2) untuk File Hasil Deobf / Decompile Apa Saja

```bash
# Mode Offline Instan (tanpa API key, tetap memberi nama + komentar pintar otomatis!)
node renamer/index.js out.lua -o renamed.lua

# Atau lewat npm script:
npm run rename -- out.lua -o renamed.lua --comments detailed
```

### 3. Slot konteks: `data[k]` jadi bernama

Skrip hasil deobf sering membawa tabel helper miliknya sendiri (`local data = {}`
lalu `data[15] = function() ... end`), karena skripnya memang mengindeks tabel itu
dengan angka. Pass `ast_polish._name_context_slots` memberi tiap slot nama dari
apa yang disimpan di dalamnya, dan **hanya** menulis nama di tempat nama itu
benar-benar menunjuk nilai yang sama:

| isi slot | nama |
|---|---|
| `game:GetService("RunService")` | `runService` |
| `ReplicatedStorage:WaitForChild("Networking")` | `networking` |
| `Vector3.new` / `CFrame.new` | `newVector3` / `newCFrame` |
| `function() ... FindFirstChild("HumanoidRootPart") ...` | `humanoidRootPart` |
| `function() return heartbeat:Wait() end` | `heartbeatWait` |
| `local state` (salinan) | `state`, tanpa alias baru |

Baca yang berada **di atas** penulisan slot, atau di dalam scope yang punya nama
sama (shadowing), tetap memakai `data[k]` -- itu bukan kosmetik, itu yang menjaga
perilaku. Pass ini jalan di Layer 1 (akhir pipeline) dan di Layer 2 (lewat
`polish_ast`), idempoten, dan setiap kasusnya diuji di `test/polish.test.js`
dengan perbandingan output Luau sebelum/sesudah.

### 4. Nama parameter & handler dari pemakaian

Lifter menyebut parameter yang tidak bisa diikutinya `argument5`, dan fungsi
tanpa nama `callback7`. Keduanya biasanya **dipakai** dengan cara yang
menjelaskan dirinya sendiri, jadi `ast_polish.name_from_usage` menamainya dari
bukti, bukan dari kamus:

| bukti di AST | nama |
|---|---|
| `p:FireServer(x)` / `p:InvokeServer(x)` | `remote` |
| `p:Connect(fn)` | `signal` |
| `p:GetAttribute("X")` | `object` (parameter itu objeknya, bukan atributnya) |
| `p:FindFirstChildOfClass("Humanoid")` | `character` |
| `p.UserInputType` / `p.Position` / `p.Character` | `input` / `part` / `player` |
| `pcall(p)` / `task.spawn(p)` | `callback` |
| `map[p]` / `#p` / `p * 2` / `.. p` | `key` / `list` / `amount` / `text` |
| `f(a, argument5)` dengan parameter `f` bernama `egg` | `egg` (dari kontrak callee) |
| `module:run(argument5)` dengan `module.run = function(self, job)` | `job` (kontrak method table) |
| `callback7` diberikan ke `:Connect` | `onHeartbeat`, `onChildAdded`, … |
| `callback7` yang hanya dipanggil, badannya membuat `Instance.new("Frame")` | `newFrame` |
| `local value7 = part.Position` | `position` (nilai itu memang field-nya) |
| `local value7 = character:FindFirstChild("Humanoid")` | `humanoid` |
| `local value7 = table.pack(...)` | `packedValues` |
| `local value7` yang cuma dibaca `.Name` / `#` / `[k]` | `object` / `list` / `key` |

Method table adalah kontrak dua arah: `module.run = function(self, job)` (atau
`local module = {run = function(self, job) end}`) membuat `module:run(x)` sah
sebagai bukti, dan sebaliknya nama parameter method bisa datang dari call site.
Kalau method tidak mendeklarasikan `self`, argumen tidak dipasangkan sama sekali
(ambigu, lebih baik tetap `argument5` daripada salah nama).

`valueN` hanya dinamai dari initialiser-nya kalau local itu **ditulis tepat
sekali** (`local value7 = part.Position`); yang ditulis ulang dianggap register
bekas dan hanya boleh memakai bukti pemakaian.

Aturan yang menjaga perilaku: nama yang **sudah hidup** di rentang yang sama
tidak dipakai, nama fungsi tidak dipakai untuk parameternya sendiri, dua
parameter satu fungsi tidak pernah dapat nama sama, nama fallback lifter
(`value12`, `number8`) tidak dipakai sebagai nama baru, dan pass berhenti saat
teks tidak berubah lagi (nama baru jadi bukti untuk putaran berikutnya). Kalau
nama terbaik sudah dipegang tetangga yang hidup, dipakai saudara bernomor
(`object` -> `object2`) supaya maknanya tetap dan tidak ada shadowing.
Urutan pembagian nama: parameter, local `argumentN`, handler, lalu `valueN` --
parameter lebih penting daripada local scratch.

### 5. Mode Full AI LLM (Opsional)
Jika ingin memakai AI LLM eksternal (AI **hanya** mengirim daftar JSON nama & komentar, lalu diterapkan oleh Verified Scope Renamer sehingga AI **tidak pernah bisa merusak kode**):

```bash
OPENAI_API_KEY="sk-..." node renamer/index.js input.lua -o output.lua --provider openai --comments detailed
# Atau Gemini / Groq / Anthropic / Ollama lokal:
GEMINI_API_KEY="..." node renamer/index.js input.lua -o output.lua --provider gemini --comments detailed
node renamer/index.js input.lua -o output.lua --provider ollama --model qwen2.5-coder:7b
```

## Rebuild Binary dari Source
Jika Anda mengubah source Go di `renamer/vendor/betterdecompiler`:

```bash
python3 renamer/build_renamer.py
```
