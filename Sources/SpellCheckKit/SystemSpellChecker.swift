import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

/// Wraps the platform spell checker.
public final class SystemSpellChecker: SpellChecker, @unchecked Sendable {
    public init() {}

    public func check(_ text: String, language: String) async -> [SpellIssue] {
        #if canImport(AppKit)
        return await MainActor.run {
            let checker = NSSpellChecker.shared
            let nsText = text as NSString
            var issues: [SpellIssue] = []
            var offset = 0

            while offset < nsText.length {
                let range = checker.checkSpelling(
                    of: text,
                    startingAt: offset,
                    language: language,
                    wrap: false,
                    inSpellDocumentWithTag: 0,
                    wordCount: nil
                )
                guard range.location != NSNotFound else { break }

                let start = text.index(text.startIndex, offsetBy: range.location)
                let end = text.index(start, offsetBy: range.length)
                let word = String(text[start..<end])
                let guesses = checker.guesses(
                    forWordRange: range,
                    in: text,
                    language: language,
                    inSpellDocumentWithTag: 0
                ) ?? []

                issues.append(
                    SpellIssue(
                        range: start..<end,
                        type: .spelling,
                        message: "Possible misspelling: \(word)",
                        suggestions: guesses
                    )
                )

                offset = range.location + range.length
            }

            return issues
        }
        #elseif canImport(UIKit)
        return await MainActor.run {
            let checker = UITextChecker()
            let nsText = text as NSString
            var issues: [SpellIssue] = []
            var offset = 0

            while offset < nsText.length {
                let range = checker.rangeOfMisspelledWord(
                    in: text,
                    range: NSRange(location: 0, length: nsText.length),
                    startingAt: offset,
                    wrap: false,
                    language: language
                )
                guard range.location != NSNotFound else { break }

                let start = text.index(text.startIndex, offsetBy: range.location)
                let end = text.index(start, offsetBy: range.length)
                let word = String(text[start..<end])
                let guesses = checker.guesses(forWordRange: range, in: text, language: language) ?? []

                issues.append(
                    SpellIssue(
                        range: start..<end,
                        type: .spelling,
                        message: "Possible misspelling: \(word)",
                        suggestions: guesses
                    )
                )

                offset = range.location + range.length
            }

            return issues
        }
        #else
        return []
        #endif
    }

    public func suggestions(for word: String, language: String) async -> [String] {
        #if canImport(AppKit)
        return await MainActor.run {
            let checker = NSSpellChecker.shared
            let range = NSRange(location: 0, length: (word as NSString).length)
            return checker.guesses(forWordRange: range, in: word, language: language, inSpellDocumentWithTag: 0) ?? []
        }
        #elseif canImport(UIKit)
        return await MainActor.run {
            let checker = UITextChecker()
            let range = NSRange(location: 0, length: (word as NSString).length)
            return checker.guesses(forWordRange: range, in: word, language: language) ?? []
        }
        #else
        return []
        #endif
    }

    public func learnWord(_ word: String) async {
        #if canImport(AppKit)
        await MainActor.run {
            NSSpellChecker.shared.learnWord(word)
        }
        #elseif canImport(UIKit)
        await MainActor.run {
            UITextChecker.learnWord(word)
        }
        #endif
    }

    public func ignoreWord(_ word: String) async {
        #if canImport(AppKit)
        await MainActor.run {
            NSSpellChecker.shared.ignoreWord(word, inSpellDocumentWithTag: 0)
        }
        #elseif canImport(UIKit)
        await MainActor.run {
            UITextChecker().ignoreWord(word)
        }
        #endif
    }
}
