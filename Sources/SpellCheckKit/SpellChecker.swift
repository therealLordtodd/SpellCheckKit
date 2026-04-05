import Foundation

public protocol SpellChecker: Sendable {
    func check(_ text: String, language: String) async -> [SpellIssue]
    func suggestions(for word: String, language: String) async -> [String]
    func learnWord(_ word: String) async
    func ignoreWord(_ word: String) async
}
