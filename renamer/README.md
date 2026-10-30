# Layer-2 Luau Renamer, Dead-Code Cleaner & Smart Commenter (`renamer/`)

Folder ini adalah **Layer 2** pasca-deobfuscation / pasca-decompile untuk mengubah output Luau/Lua hasil deobfuscator (maupun hasil `decompile()` executor seperti Konstant, Medal, Oracle, dll.) menjadi source code yang bersih, bebas sampah, memiliki nama variabel/fungsi bermakna, serta dilengkapi komentar penjelasan otomatis **tanpa merusak logika runtime**.

## Mesin Open-Source yang Digunakan

Sesuai prinsip *zero fragile regex*, sistem ini dibangun langsung di atas **3 fondasi open-source resmi**:

1. **[`seaofvoices/darklua`](https://github.com/seaofvoices/darklua)** (`renamer/vendor/darklua`, MIT License — Rust/WASM Luau AST Compiler)
   - Menghapus kode mati & menyederhanakan ekspresi secara sah di level AST Luau (`compute_expression`, `convert_index_to_field`, `filter_after_early_return`, `remove_empty_do`, `remove_unused_if_branch`, `remove_unused_variable`, `remove_unused_while`).
2. **[`officialmelon/BetterDecompiler` v2.0.0](https://github.com/officialmelon/BetterDecompiler)** (`renamer/vendor/betterdecompiler` -> `renamer/bin/betterdecompiler`)
   - Lexer + Scope-Resolving Luau Parser + **Verified Renamer (`sameResolution`)**: setiap perubahan nama variabel di-parse ulang dan diverifikasi bahwa 100% referensi token tetap menunjuk ke binding yang persis sama (mustahil terjadi *variable shadowing* atau perubahan perilaku!).
   - Diperluas khusus untuk mengenali pola variabel/fungsi DeobfLuraph, API Roblox & Executor (`getgenv`, `gethui`, `readfile`, `writefile`, `request`, `WebSocket`, `Drawing`, `fireproximityprompt`, dll.), serta **Smart Contextual Commenter** (offline instan maupun berbasis AI LLM).
3. **Official Roblox Luau AST (`./bin/luau-ast`) + Deobf Chaff Polisher (`core/ast_polish.py`)**
   - Menyapu sisa artefak VM Luraph (argumen dummy state-key, cabang *opaque predicate* konstan, rantai `bit32`/`table.pack` mati, IIFE pembungkus) dan memvalidasi sintaks Luau akhir.

---

## Cara Pakai

### 1. Sekali Jalan Bersama Deobfuscator (`deob.js --rename`)
Jalankan Layer 1 (Devirtualizer Luraph v15.0/v15.1) + Layer 2 (Garbage Cleaner + Verified Renamer + Smart Comments) sekaligus dalam **satu perintah**:

```bash
node deob.js samples/StealAnEggg_v15.1_obfuscated.lua -o samples/StealAnEggg_v15.1_Renamed.lua --rename
```

Opsi tambahan pada `deob.js`:
- `--comments light` *(default)* | `--comments detailed` | `--comments none`
- `--ai-provider <openai|gemini|anthropic|groq|deepseek|openrouter|xai|ollama|lmstudio>`
- `--ai-model <model-name>`

### 2. Mandiri (Standalone Layer 2) untuk File Hasil Deobf / Decompile Apa Saja

```bash
# Mode Offline Instan (tanpa API key, tetap memberi nama + komentar pintar otomatis!)
node renamer/index.js samples/StealAnEggg_v15.1_Deobfuscated.lua -o samples/StealAnEggg_v15.1_Renamed.lua

# Atau lewat npm script:
npm run rename -- samples/StealAnEggg_v15.1_Deobfuscated.lua -o samples/StealAnEggg_v15.1_Renamed.lua --comments detailed
```

### 3. Mode Full AI LLM (Opsional)
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
