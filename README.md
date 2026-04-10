# SpellCheckKit

SpellCheckKit provides spelling checks, suggestions, user dictionary actions, and deterministic autocorrect replacement helpers.

## Quick Start

```swift
import SpellCheckKit

let checker = SystemSpellChecker()
let issues = await checker.check("Ths sentence", language: "en_US")
let suggestions = await checker.suggestions(for: "Ths", language: "en_US")

let autocorrect = AutocorrectEngine()
autocorrect.addReplacement(original: "teh", replacement: "the")
let result = autocorrect.process("teh title")
```

## Key Types
- `SpellChecker`: Async protocol for checking text, requesting suggestions, learning words, and ignoring words.
- `SystemSpellChecker`: AppKit/UIKit-backed implementation.
- `SpellIssue`: Issue range, type, message, suggestions, and helper `word(in:)`.
- `AutocorrectEngine`: Observable replacement engine with `process(_:)`, `addReplacement`, and `removeReplacement`.
- `UserDictionary`: Actor-isolated custom word set.

## Common Operations
- Use `SystemSpellChecker` in production unless tests need a fake `SpellChecker`.
- Call `learnWord(_:)` for accepted custom words and `ignoreWord(_:)` for session-level dismissals.
- Use `AutocorrectEngine` for deterministic typed replacements before or alongside platform spell checking.
- Use `UserDictionary.contains(_:)` to suppress app-level custom dictionary hits.

## Testing

Run:

```bash
swift test
```
