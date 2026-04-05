import Foundation

public actor UserDictionary {
    private var words: Set<String>

    public init(words: Set<String> = []) {
        self.words = words
    }

    public func addWord(_ word: String) {
        words.insert(word.lowercased())
    }

    public func removeWord(_ word: String) {
        words.remove(word.lowercased())
    }

    public func contains(_ word: String) -> Bool {
        words.contains(word.lowercased())
    }

    public var allWords: Set<String> {
        words
    }

    public var count: Int {
        words.count
    }
}
