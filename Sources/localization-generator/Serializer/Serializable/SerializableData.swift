//
//  File.swift
//  
//
//  Created by Nisse Bergman on 2022-11-26.
//

import Foundation


struct SerializableStruct {
    let namespace: [String]
    let structName: String
    let functions: [SerializableFunction]
    let children: [SerializableStruct]

    var string: String {
        return """
        extension \(namespace.joined(separator: ".")) {
            struct \(structName) {
                private init() {}

        """
        +

        functions.map(\.string).joined(separator: "\n").indented(2)

        +

        children.map(\.string).joined(separator: "\n").indented(2)

        +

        """

            }
        }

        """
    }
}

extension String {
    func indented(_ indents: Int) -> String {
        let indentation = 4 * indents
        let indentationString = Array(repeating: " ", count: indentation).joined()
        return self.split(separator: "\n")
            .map{ indentationString + $0}
            .joined(separator: "\n")
    }
}

struct SerializableFunction {
    let functionName: String
    let arguments: [SerializableFunctionArgument]
    let body: [SerializableTranslation]

    var string: String {

        let argumentString = (arguments.map(\.asArgument) + ["locale: SupportedLanguage = Locale.current.supportedLanguage"]).joined(separator: ", ")

        let argumentCallString = (arguments.map{$0.name + ": " + $0.name} + ["locale: .en_GB"]).joined(separator: ", ")
        let missingLanguageCases = Set(SerializableLanguage.allCases).subtracting(body.map(\.language)).map{$0}
        let missingCases = missingLanguageCases.map{".\($0.string)"}.joined(separator: ", ")

        let fallbackFunction = "Self.\(functionName)(\(argumentCallString))"

        return """
        static func \(functionName)(\(argumentString)) -> String {
            switch locale {
        
        """
        +
        arguments.reduce(body.map{$0.string(fallbackFunction)}.joined(separator: "\n").indented(2)){ function, argument in
            return function.replacingOccurrences(of: argument.asReplacementString, with: "\\(\(argument.name))")
        }
        +

        """

                \(missingLanguageCases.isEmpty ? "" : "case \(missingCases):")
                    \(missingLanguageCases.isEmpty ? "" : "return \(fallbackFunction)")
            }

        }
        """

    }
}

enum SerializableFunctionArgument {
    case integer(name: String, parameterName: String)
    case string(name: String, parameterName: String)
    case float(name: String, parameterName: String)

    var name: String {
        switch self {
            case .integer(let name, _):
                return name
            case .string(let name, _):
                return name
            case .float(let name, _):
                return name
        }
    }

    var asArgument: String {
        switch self {
            case .integer(let name, _):
                return "\(name): Int"
            case .string(let name, _):
                return "\(name): String"
            case .float(let name, _):
                return "\(name): Double"
        }
    }

    var asReplacementString: String {
        switch self {
            case .integer(_, let parameterName):
                return "[%i:\(parameterName)]"
            case .string(_, let parameterName):
                return "[%s:\(parameterName)]"
            case .float(_, let parameterName):
                return "[%f:\(parameterName)]"
        }

    }
}

enum SerializableTranslation {
    case singular(language: SerializableLanguage, string: String)
    case plural(language: SerializableLanguage,
                pluralKey: SerializableFunctionArgument,
                pluralCases: [SerializablePluralCaseTranslation])

    func string(_ fallbackFunction: String) -> String {
        switch self {
            case .singular(let language, let string):
                return singularTranslationSwitch(for: language, translation: string)
            case .plural(let language, let pluralKey, let pluralCases):
                return pluralTranslationSwitch(for: language, with: pluralCases, and: pluralKey, using: fallbackFunction)
        }
    }

    var language: SerializableLanguage {
        switch self {
            case .singular(let language, _):
                return language
            case .plural(let language, _, _):
                return language
        }
    }

    private func pluralTranslationSwitch(for language: SerializableLanguage,
                                         with pluralCases: [SerializablePluralCaseTranslation],
                                         and pluralKey: SerializableFunctionArgument,
                                         using fallbackFunction: String) -> String {

        let pluralCaseString = pluralCases.map(\.string).joined(separator: "\n")

        //TODO: This can fall through into an eternal loop if the plural case for english is missing
        // so that really has to be taken care of beforehand
        let missingPluralCases = Set(PluralCase.allCases).subtracting(pluralCases.map(\.pluralCase)).map{$0}
        let missingCases = missingPluralCases.map{".\($0)"}.joined(separator: ", ")

        return """

        case .\(language.string):
            switch locale.pluralCase(for: \(pluralKey.name)) {

        """
        +
        pluralCaseString.indented(2)
        +
        """

                \(missingPluralCases.isEmpty ? "" : "case \(missingCases):")
                    \(missingPluralCases.isEmpty ? "" : "return \(fallbackFunction)")
            }
        """

    }

    private func singularTranslationSwitch(for language: SerializableLanguage, translation: String) -> String {

        let joinedTranslation = translation.split(separator: "\n").joined(separator: "\\n")

        return """

        case .\(language.string):
            return "\(joinedTranslation)"

        """
    }
}

enum SerializablePluralCaseTranslation {
    case zero(string: String)
    case one(string: String)
    case few(string: String)
    case many(string: String)
    case other(string: String)

    var pluralCase: PluralCase {
        switch self {
            case .zero:
                return .zero
            case .one:
                return.one
            case .few:
                return .few
            case .many:
                return .many
            case .other:
                return .other
        }
    }

    var string: String {
        return """
               case .\(name):
                   return "\(translation)"
               """
    }

    var name: String {
        switch self {
            case .zero(_):
                return "zero"
            case .one(_):
                return "one"
            case .few(_):
                return "few"
            case .many(_):
                return "many"
            case .other(_):
                return "other"
        }
    }

    var translation: String {

        switch self {
            case .zero(let string):
                return string.split(separator: "\n").joined(separator: "\\n")
            case .one(let string):
                return string.split(separator: "\n").joined(separator: "\\n")
            case .few(let string):
                return string.split(separator: "\n").joined(separator: "\\n")
            case .many(let string):
                return string.split(separator: "\n").joined(separator: "\\n")
            case .other(let string):
                return string.split(separator: "\n").joined(separator: "\\n")
        }

    }
}

enum SerializableLanguage: CaseIterable, Equatable {
    case en_GB
    case sv_SE
    case ru_RU

    var string: String {
        switch self {
            case .en_GB:
                return "en_GB"
            case .sv_SE:
                return "sv_SE"
            case .ru_RU:
                return "ru_RU"
        }
    }
}
