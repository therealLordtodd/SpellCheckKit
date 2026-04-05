import Foundation
import Testing
@testable import SpellCheckKit

@MainActor
@Suite("AutocorrectEngine Tests")
struct AutocorrectEngineTests {
    @Test func disabledEnginePassesThrough() {
        let engine = AutocorrectEngine(isEnabled: false, customReplacements: ["teh": "the"])
        let result = engine.process("teh quick")
        #expect(result.correctedText == "teh quick")
        #expect(result.replacements.isEmpty)
    }

    @Test func basicReplacement() {
        let engine = AutocorrectEngine(customReplacements: ["teh": "the"])
        let result = engine.process("teh quick brown fox")
        #expect(result.correctedText == "the quick brown fox")
        #expect(result.replacements.count == 1)
    }

    @Test func multipleReplacements() {
        let engine = AutocorrectEngine(customReplacements: ["teh": "the", "adn": "and"])
        let result = engine.process("teh cat adn dog")
        #expect(result.correctedText == "the cat and dog")
    }

    @Test func wordBoundaryRespected() {
        let engine = AutocorrectEngine(customReplacements: ["the": "THE"])
        let result = engine.process("other things")
        #expect(result.correctedText == "other things")
    }

    @Test func addAndRemoveReplacement() {
        let engine = AutocorrectEngine()
        engine.addReplacement(original: "btw", replacement: "by the way")
        let result = engine.process("btw it works")
        #expect(result.correctedText == "by the way it works")
        engine.removeReplacement(original: "btw")
        let result2 = engine.process("btw it works")
        #expect(result2.correctedText == "btw it works")
    }
}
