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

---

## Family Membership — Document Editor

This primitive is a member of the Document Editor primitive family. It participates in shared conventions and consumes or publishes cross-primitive types used by the rich-text / document / editor stack.

**Before modifying public API, shared conventions, or cross-primitive types, consult:**
- `../RichTextEditorKit/docs/plans/2026-04-19-document-editor-dependency-audit.md` — who depends on whom, who uses which conventions
- `/Users/todd/Building - Apple/Packages/CONVENTIONS/` — shared patterns this primitive participates in
- `./MEMBERSHIP.md` in this primitive's root — specific list of conventions, shared types, and sibling consumers

**Changes that alter public API, shared type definitions, or convention contracts MUST include a ripple-analysis section in the commit or PR description** identifying which siblings could be affected and how.

Standalone consumers (apps just importing this primitive) are unaffected by this discipline — it applies only to modifications to the primitive itself.
