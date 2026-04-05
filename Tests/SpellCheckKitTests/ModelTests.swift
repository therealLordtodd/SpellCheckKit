import Foundation
import Testing
@testable import SpellCheckKit

@Suite("SpellCheckKit Model Tests")
struct ModelTests {
    @Test func issueTypeRawValues() {
        #expect(IssueType.spelling.rawValue == "spelling")
        #expect(IssueType.grammar.rawValue == "grammar")
        #expect(IssueType.style.rawValue == "style")
        #expect(IssueType.capitalization.rawValue == "capitalization")
    }

    @Test func spellIssueExtractsWord() {
        let text = "This is a tset of spelling"
        let start = text.index(text.startIndex, offsetBy: 10)
        let end = text.index(start, offsetBy: 4)
        let issue = SpellIssue(range: start..<end, type: .spelling, message: "Misspelling")
        #expect(issue.word(in: text) == "tset")
    }
}
