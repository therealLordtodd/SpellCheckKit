import Foundation
import Testing
@testable import SpellCheckKit

@Suite("UserDictionary Tests")
struct UserDictionaryTests {
    @Test func addAndContains() async {
        let dictionary = UserDictionary()
        await dictionary.addWord("Xcode")
        let contains = await dictionary.contains("xcode")
        #expect(contains == true)
    }

    @Test func caseInsensitive() async {
        let dictionary = UserDictionary()
        await dictionary.addWord("SwiftUI")
        let contains = await dictionary.contains("swiftui")
        #expect(contains == true)
    }

    @Test func removeWord() async {
        let dictionary = UserDictionary()
        await dictionary.addWord("test")
        await dictionary.removeWord("test")
        let contains = await dictionary.contains("test")
        #expect(contains == false)
    }

    @Test func countAndAllWords() async {
        let dictionary = UserDictionary(words: ["hello", "world"])
        let count = await dictionary.count
        let all = await dictionary.allWords
        #expect(count == 2)
        #expect(all.contains("hello"))
        #expect(all.contains("world"))
    }
}
