import Foundation
import Observation

public struct AutocorrectResult: Sendable {
    public var correctedText: String
    public var replacements: [AutocorrectReplacement]

    public init(correctedText: String, replacements: [AutocorrectReplacement] = []) {
        self.correctedText = correctedText
        self.replacements = replacements
    }
}

public struct AutocorrectReplacement: Sendable {
    public var original: String
    public var replacement: String
    public var range: Range<String.Index>

    public init(original: String, replacement: String, range: Range<String.Index>) {
        self.original = original
        self.replacement = replacement
        self.range = range
    }
}

@MainActor
@Observable
public final class AutocorrectEngine {
    public var isEnabled: Bool
    public var customReplacements: [String: String]

    public init(
        isEnabled: Bool = true,
        customReplacements: [String: String] = [:]
    ) {
        self.isEnabled = isEnabled
        self.customReplacements = customReplacements
    }

    public func process(_ input: String) -> AutocorrectResult {
        guard isEnabled else {
            return AutocorrectResult(correctedText: input)
        }

        var result = input
        var replacements: [AutocorrectReplacement] = []

        for (original, replacement) in customReplacements.sorted(by: { $0.key.count > $1.key.count }) {
            var searchStart = result.startIndex
            while let range = result.range(of: original, range: searchStart..<result.endIndex) {
                let isStartBoundary = range.lowerBound == result.startIndex ||
                    !result[result.index(before: range.lowerBound)].isLetter
                let isEndBoundary = range.upperBound == result.endIndex ||
                    !result[range.upperBound].isLetter

                if isStartBoundary && isEndBoundary {
                    replacements.append(
                        AutocorrectReplacement(
                            original: original,
                            replacement: replacement,
                            range: range
                        )
                    )
                    result.replaceSubrange(range, with: replacement)
                    searchStart = result.index(
                        range.lowerBound,
                        offsetBy: replacement.count,
                        limitedBy: result.endIndex
                    ) ?? result.endIndex
                } else {
                    searchStart = range.upperBound
                }
            }
        }

        return AutocorrectResult(correctedText: result, replacements: replacements)
    }

    public func addReplacement(original: String, replacement: String) {
        customReplacements[original] = replacement
    }

    public func removeReplacement(original: String) {
        customReplacements.removeValue(forKey: original)
    }
}
