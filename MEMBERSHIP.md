# SpellCheckKit — Document Editor Family Membership

This primitive is a member of the Document Editor primitive family. It provides platform spell-checking and autocorrect support for editing surfaces.

## Conventions This Primitive Participates In

- [ ] [shared-types](../CONVENTIONS/shared-types-convention.md) — not participating (no cross-primitive types beyond its own consumer-facing API)
- [ ] [typed-static-constants](../CONVENTIONS/typed-static-constants-convention.md) — not participating
- [x] [document-editor-family-membership](../CONVENTIONS/document-editor-family-membership.md)

## Shared Types This Primitive Defines

- Spell-check result types, suggestion types, language-identification surface
- Consumed by: `RichTextPrimitive`, `RichTextEditorKit`, hosts with text-editing surfaces

## Shared Types This Primitive Imports

- (none from the family — Foundation / platform APIs only)

## Siblings That Hard-Depend on This Primitive

- `RichTextPrimitive` — invokes spell-check during editing
- `RichTextEditorKit` — re-exports spell-check surface

## Ripple-Analysis Checklist Before Modifying Public API

1. Changes to spell-check result types: affects how RichTextPrimitive renders corrections; test through the composition.
2. Platform-specific behavior differences (macOS vs. iOS): keep the public API platform-agnostic; platform specifics stay internal.
3. Consult [dependency audit](../RichTextEditorKit/docs/plans/2026-04-19-document-editor-dependency-audit.md).
4. Document ripple impact in the commit/PR.

## Scope of Membership

Applies to modifications of SpellCheckKit's own code. Consumers just importing for their own app are unaffected.
