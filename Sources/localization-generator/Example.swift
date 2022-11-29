import Foundation

struct Localization {
    private init() {}
}

extension Localization {
    struct Klondike {
        private init() {}
    }
}

extension Localization.Klondike {
    static func buttonName(color: String, locale: SupportedLanguage = Locale.current.supportedLanguage) -> String {
        switch locale {
            case .en_GB:
                return "This is a \(color) ball"
            case .sv_SE:
                return "Detta är en \(color) boll"
            case .ru_RU:
                return "Это \(color) шар"


        }
    }
    static func bananas(bananas: Int, locale: SupportedLanguage = Locale.current.supportedLanguage) -> String {
        switch locale {
            case .en_GB:
                switch locale.pluralCase(for: bananas) {
                    case .zero:
                        return "No bananas"
                    case .one:
                        return "One banana"
                    case .other:
                        return "\(bananas) bananas"
                    case .few, .two, .many:
                        return Self.bananas(bananas: bananas, locale: .en_GB)
                }
            case .ru_RU:
                switch locale.pluralCase(for: bananas) {
                    case .zero:
                        return "нет бананов"
                    case .few:
                        return "\(bananas) банан"
                    case .many:
                        return "\(bananas) банана"
                    case .other:
                        return "\(bananas) бананов"
                    case .one, .two:
                        return Self.bananas(bananas: bananas, locale: .en_GB)
                }
            case .sv_SE:
                return Self.bananas(bananas: bananas, locale: .en_GB)
        }
    }
}



