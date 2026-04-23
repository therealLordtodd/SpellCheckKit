# SpellCheckKit — Project Constitution

**Created:** 2026-04-16
**Authors:** Todd Cowing + Claude (Opus 4.7)

This document records the *why* behind foundational decisions. It is written for future collaborators — human and AI — who weren't in the room when these choices were made. The development plan tells you what we're building. AGENTS.md tells you how to build it. This document tells you why we made the decisions we made, and where we believe this is going.

Fill in the project-specific sections as decisions are made. The **Founding Principles** apply to every project in the portfolio without exception — they are the intent behind the work. The **Portfolio-Wide Decisions** are pre-filled conventional choices that follow from those principles; they apply unless explicitly overridden here with a documented reason.

---

## What SpellCheckKit Is Trying to Be

SpellCheckKit is a focused spelling package for text-editing apps. It wraps the platform spell checker (`NSSpellChecker` or `UITextChecker`) behind an async `SpellChecker` protocol, provides a deterministic app-owned `AutocorrectEngine` for predictable substitutions, and offers an actor-backed `UserDictionary` for custom word sets. It is for apps that need a unified async spell-check interface across macOS and iOS, testable behavior through a small protocol, and autocorrect rules that do not depend on opaque OS heuristics. It is not a full grammar, style, or NLP-heavy proofreading suite. The central insight is that spelling is a well-bounded concern that deserves its own testable seam, separate from document editing and from the larger review/proofreading surface.

---

## Foundational Decisions

### Shared Portfolio Doctrine

The shared founding principles and portfolio-wide defaults now live in the Foundation Libraries wiki:

- `/Users/todd/Library/CloudStorage/GoogleDrive-todd@cowingfamily.com/My Drive/The Commons/Libraries/Foundation Libraries/operations/portfolio-doctrine.md`

Use this local constitution for project-specific decisions, not copied portfolio boilerplate.

---

### Project-Specific Decisions

*Add an entry here for every significant architectural, tooling, or directional decision made for this project. Write it at decision time, not retroactively. Future collaborators need to understand the reasoning, not just the outcome.*

*Initial decisions summarized from CLAUDE.md:*

#### `SpellChecker` Is Async and Sendable

**Decision:** The `SpellChecker` protocol is async and Sendable so rich text services can call it without assuming a UI thread.

**Why:** Editor services in the portfolio run off the main actor — spell checks are a good example of work that should not block the rendering path. A Sendable async protocol lets consumers schedule checks safely and swap implementations (system, fake, domain-specific) at the seam.

**Trade-offs accepted:** Callers must handle async concurrency. Implementations that internally dispatch to the main actor (like `SystemSpellChecker`) must do so behind the async boundary.

---

#### Platform APIs Contained in `SystemSpellChecker`

**Decision:** Platform spell-check APIs (`NSSpellChecker`, `UITextChecker`) live inside `SystemSpellChecker`. Both AppKit and UIKit branches are real implementations whenever the package advertises macOS and iOS support.

**Why:** Keeping platform code in one type isolates the unavoidable `#if canImport` branches and prevents them from leaking across the package. Advertising both platforms while only implementing one would silently break consumers on the other platform.

**Trade-offs accepted:** Contributors must maintain both platform branches when the system checker changes. Tests must cover both via deliberate simulator/iOS builds from dependents.

---

#### `SpellIssue.range` Is a `Range<String.Index>`

**Decision:** `SpellIssue.range` uses `Range<String.Index>`. Integer offsets are only computed at integration boundaries.

**Why:** `Range<String.Index>` is the string-safe shape for editing code that has to respect grapheme boundaries. Integer offsets look convenient but silently break on multibyte content when mapped back to the source string.

**Trade-offs accepted:** UI code that needs integer offsets (for AppKit/UIKit APIs, for example) must convert at its own boundary. The conversion is the right place for that to happen, not inside the model.

---

#### `UserDictionary` Is Actor-Isolated and Does Not Persist Itself

**Decision:** `UserDictionary` is actor-isolated. Persistence is owned by the host app.

**Why:** Actor isolation makes concurrent additions and lookups safe without forcing a specific storage shape. Persistence policy (when to save, where, in what format) varies too much between hosts to bake in — the host's persistence layer is the right owner.

**Trade-offs accepted:** Hosts must save and restore the dictionary themselves; a fresh `UserDictionary` does not survive relaunch on its own.

---

*Add more entries as decisions are made.*

---

## Tech Stack and Platform Choices

**Platform:** macOS 15+ and iOS 17+ (cross-platform Swift package)
**Primary language:** Swift 6.0
**UI framework:** None directly — `SystemSpellChecker` internally dispatches to platform spell-check APIs
**Data layer:** In-memory actor-isolated `UserDictionary`; persistence is owned by the host app

**Why this stack:** Spell checking is a small, well-bounded capability that needs a consistent async shape across both Apple platforms. Swift 6 concurrency and a single-protocol surface give consumers a clean seam without over-engineering a feature that should stay focused.

---

## Who This Is Built For

*Who are the primary users or operators of this software? Humans, AI agents, or both? This shapes everything from UI density to conductorship defaults.*

[ ] Primarily humans
[ ] Primarily AI agents
[ ] Both, roughly equally
[ ] Both — humans build it, AIs operate it
[X] Both — AIs build it, humans operate it

**Notes:** Foundation kit. Humans interact with spell check through host editor UI; AIs build and maintain the kit itself and can request checks, learn words, or run autocorrect rules through the same protocol in AI-collaborative editors.

---

## Where This Is Going

[To be filled in as project direction crystallizes.]

---

## Open Questions

*None recorded yet.*

---

## Amendment Process

Use this process whenever a foundational decision changes or a new decision is added.

1. Update the relevant section in this constitution in the same change as the code/docs that motivated the update.
2. For each new or changed decision entry, include:
   - **Decision**
   - **Why**
   - **Trade-offs accepted**
   - **Revisit trigger** (what condition should cause reconsideration)
3. Add a matching row in the **Decision Log** with date and a concise summary.
4. If the amendment changes implementation rules, update `AGENTS.md` and any affected style guide files in the same change.
5. Record who approved the amendment (human + AI collaborator when applicable).

Minor wording clarifications that do not change meaning do not require a new decision entry, but should still be noted in the Decision Log.

---

## Decision Log

*Brief chronological record of significant decisions. Add an entry whenever a non-trivial decision is made that isn't already captured in the sections above.*

| Date | Decision | Decided by |
|------|----------|------------|
| 2026-04-16 | Constitution created and Founding Principles established | Both |
