# SpellCheckKit

`SpellCheckKit` is a focused spelling package for text-editing apps. It wraps the platform spell checker behind an async protocol, adds a deterministic autocorrect engine, and provides an actor-backed user dictionary.

It is for spelling workflows. It is not a full proofreading suite, grammar engine, or document editor by itself.

## When To Use It

Use `SpellCheckKit` when you want:

- one async spell-checking interface across macOS and iOS
- testable spell-check behavior through a small protocol
- deterministic app-owned autocorrect rules
- a custom user dictionary you can manage independently from platform APIs

Do not use it if you need full grammar analysis, style review, or NLP-heavy proofreading out of the box.

## What Ships

The package has three main pieces:

- `SpellChecker` and `SystemSpellChecker`
- `AutocorrectEngine`, `AutocorrectResult`, and `AutocorrectReplacement`
- `UserDictionary`

It also defines `SpellIssue` and `IssueType` for transporting spell-check results through your app.

## Core Types

| Type | What it does |
| --- | --- |
| `SpellChecker` | Async protocol for checking text, asking for suggestions, learning words, and ignoring words |
| `SystemSpellChecker` | Production implementation backed by `NSSpellChecker` or `UITextChecker` |
| `SpellIssue` | One detected issue, including range, message, and suggestions |
| `IssueType` | Semantic issue category carried by `SpellIssue` |
| `AutocorrectEngine` | App-owned replacement engine for deterministic text substitutions |
| `AutocorrectResult` | Corrected text plus the replacements that were applied |
| `AutocorrectReplacement` | One original/replacement pair plus its range |
| `UserDictionary` | Actor-backed custom word set |

## Examples

### 1. Check text and show suggestions

```swift
import SpellCheckKit

let checker = SystemSpellChecker()
let text = "Ths sentence has erors."
let issues = await checker.check(text, language: "en_US")

for issue in issues {
    print(issue.word(in: text))
    print(issue.suggestions.prefix(3))
}
```

Today, `SystemSpellChecker` primarily emits `.spelling` issues. The broader `IssueType` model is there so host apps have room to grow later.

### 2. Ask for suggestions directly

```swift
let checker = SystemSpellChecker()
let suggestions = await checker.suggestions(for: "erors", language: "en_US")
```

This is a good fit for contextual menus or inline correction popovers.

### 3. Build deterministic autocorrect rules

```swift
import SpellCheckKit

let engine = AutocorrectEngine()
engine.addReplacement(original: "teh", replacement: "the")
engine.addReplacement(original: "dont", replacement: "don't")

let result = engine.process("teh dog dont bark")
print(result.correctedText)
```

This engine is app-owned and predictable. It does not depend on hidden OS heuristics.

### 4. Use a user dictionary

```swift
import SpellCheckKit

let dictionary = UserDictionary()

await dictionary.addWord("SwiftUI")
await dictionary.addWord("visionOS")

let containsWord = await dictionary.contains("swiftui")
let allWords = await dictionary.allWords
```

The dictionary is case-insensitive and actor-isolated.

### 5. Filter spell-check results against your user dictionary

```swift
let checker = SystemSpellChecker()
let dictionary = UserDictionary(words: ["SwiftUI", "visionOS"])

let issues = await checker.check(text, language: "en_US")
var filtered: [SpellIssue] = []

for issue in issues {
    let word = issue.word(in: text)
    if await !dictionary.contains(word) {
        filtered.append(issue)
    }
}
```

In a real app you would usually do this in your editor service or feature model, not directly in the view.

### 6. Use a fake in tests

```swift
import SpellCheckKit

struct FakeSpellChecker: SpellChecker {
    func check(_ text: String, language: String) async -> [SpellIssue] { [] }
    func suggestions(for word: String, language: String) async -> [String] { ["fixed"] }
    func learnWord(_ word: String) async {}
    func ignoreWord(_ word: String) async {}
}
```

This is one of the nicest parts of the package: the protocol is tiny, so tests stay easy to control.

## Wiring It Into Your App

The clean host-app pattern is:

1. Inject something that conforms to `SpellChecker`.
2. Run checks in your editor or text-feature layer.
3. Convert `SpellIssue.range` into whatever selection or highlighting model your app uses.
4. Keep `AutocorrectEngine` and `UserDictionary` as app-owned collaborators around that flow.

Practical guidance:

- use `SystemSpellChecker` for production and a fake for tests
- keep the user dictionary in your app’s persistence layer if you want it to survive relaunches
- use `AutocorrectEngine` when you want predictable substitutions, not when you want opaque platform autocorrect behavior
- run spell checks off the view boundary and feed results into UI state from your editor model or controller

## Constraints And Notes

- `SystemSpellChecker` is async, but it still dispatches to the platform spell checker on the main actor internally.
- `UserDictionary` does not automatically persist itself.
- `IssueType` is broader than the current platform implementation; do not assume grammar or style diagnostics are already shipped.
- `SpellIssue.range` uses `Range<String.Index>`, which is the right shape for string-safe editing code but may need adaptation at UI boundaries.

## Platform Support

- macOS 15+
- iOS 17+
