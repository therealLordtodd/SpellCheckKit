# SpellCheckKit Working Guide

## Purpose
SpellCheckKit provides platform spell checking, autocorrect replacements, spell issue models, and a small user dictionary for rich text editors.

## Key Directories
- `Sources/SpellCheckKit`: Spell checker protocol, system backend, autocorrect engine, issue model, and user dictionary.
- `Tests/SpellCheckKitTests`: Autocorrect, model, and dictionary tests.

## Architecture Rules
- Keep `SpellChecker` async and Sendable so rich text services can call it without assuming a UI thread.
- Keep platform APIs contained in `SystemSpellChecker`. AppKit and UIKit branches must both be real implementations when the package advertises macOS and iOS support.
- Preserve `SpellIssue.range` as a `Range<String.Index>`; convert to integer offsets only at integration boundaries.
- Keep `UserDictionary` actor-isolated.

## Testing
- Run `swift test` before committing.
- Add deterministic tests for `AutocorrectEngine` and `UserDictionary`.
- When touching `SystemSpellChecker`, also run an iOS simulator build from a dependent package so UIKit code compiles.
