import Foundation

public enum IssueType: String, Codable, Sendable {
    case spelling
    case grammar
    case style
    case capitalization
}

public struct SpellIssue: Identifiable, Sendable {
    public let id: UUID
    public var range: Range<String.Index>
    public var type: IssueType
    public var message: String
    public var suggestions: [String]

    public init(
        id: UUID = UUID(),
        range: Range<String.Index>,
        type: IssueType,
        message: String,
        suggestions: [String] = []
    ) {
        self.id = id
        self.range = range
        self.type = type
        self.message = message
        self.suggestions = suggestions
    }

    public func word(in text: String) -> String {
        String(text[range])
    }
}
