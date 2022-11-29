import Foundation

extension Locale {
    var supportedLanguage: SupportedLanguage {
        //TODO: This does not take into account regions
        switch self.identifier {
            case "en_GB":
                return .en_GB
            case "ru_RU":
                return .ru_RU
            case "sv_SE":
                return .sv_SE
            default:
                return .en_GB
        }
    }
}



enum SupportedLanguage: CaseIterable, Equatable {
    case en_GB
    case sv_SE
    case ru_RU

    func pluralCase(for number: Int) -> PluralCase {
        // Rules can be found here:
        //https://unicode-org.github.io/cldr-staging/charts/latest/supplemental/language_plural_rules.html
        switch self {
            case .en_GB:
                return brittishPluralCase(for: number)
            case .sv_SE:
                return swedishPluralCase(for: number)
            case .ru_RU:
                return russianPluralCase(for: number)
        }
    }

    private func brittishPluralCase(for number: Int) -> PluralCase {
        let (_, i, v, _) = getPluralOperands(for: number)

        if i == 0, v == 0 {
            return .one
        }

        return .other
    }

    private func swedishPluralCase(for number: Int) -> PluralCase {
        let (_, i, v, _) = getPluralOperands(for: number)

        if i == 0, v == 0 {
            return .one
        }

        return .other
    }

    private func russianPluralCase(for number: Int) -> PluralCase {
        let (_, i, v, _) = getPluralOperands(for: number)

        if v == 0 {
            if i % 10 == 1, i % 100 != 11 {
                return .one
            }

            if (2...4).contains(i % 10), !(12...14).contains(i % 100) {
                return .few
            }

            if i % 10 == 0 {
                return .many
            }

            if (5...9).contains(i % 10) {
                return .many
            }

            if (11...14).contains(i % 100) {
                return .many
            }
        }


        return .other
    }

    /*
     n    the absolute value of N.*
     i    the integer digits of N.*
     v    the number of visible fraction digits in N, with trailing zeros.*
     w    the number of visible fraction digits in N, without trailing zeros.*
     f    the visible fraction digits in N, with trailing zeros, expressed as an integer.*
     t    the visible fraction digits in N, without trailing zeros, expressed as an integer.*
     c    compact decimal exponent value: exponent of the power of 10 used in compact decimal formatting.
     e    a deprecated synonym for ‘c’. Note: it may be redefined in the future.
     */
    private func getPluralOperands(for number: Int) -> (n:Int, i: Int, v: Int, w: Int) {
        let string = "\(number)"
        let n = abs(number)
        let i = string.count
        let v = 0
        let w = 0
        return (n,i, v, w)
    }
}
