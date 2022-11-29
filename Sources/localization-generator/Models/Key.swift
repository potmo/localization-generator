import Foundation

struct Project: Codable {

    let id: String
    let name: String
    let languages: [ProjectLanguage]

    enum CodingKeys: String, CodingKey {
        case id = "project_id"
        case name = "project_name"
        case languages = "languages"
    }
}

struct ProjectLanguage: Codable {
    let id: Int
    let iso: String

    enum CodingKeys: String, CodingKey {
        case id = "language_id"
        case iso = "language_iso"
    }
}

struct Keys: Codable {
    let projectId: String
    let keys: [Key]

    enum CodingKeys: String, CodingKey {
        case projectId = "project_id"
        case keys = "keys"
    }
}

struct Key: Codable {
    let id: String
    let name: String
    let translations: [Translation]
    let isPlural: Bool
    let isHidden: Bool
    let isArchived: Bool
    let charLimit: Int

    enum CodingKeys: String, CodingKey {
        case id = "key_id"
        case name = "key_name"
        case translations = "translations"
        case isPlural = "is_plural"
        case isHidden = "is_hidden"
        case isArchived = "is_archived"
        case charLimit = "char_limit"
    }
}

struct Translation: Codable {
    let id: String
    let languageCode: String
    let translation: String //this can be a json string if plural case

    enum CodingKeys: String, CodingKey {
        case id = "translation_id"
        case languageCode = "language_iso"
        case translation = "translation"
    }
}



