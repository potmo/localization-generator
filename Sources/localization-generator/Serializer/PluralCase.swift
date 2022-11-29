//
//  File.swift
//  
//
//  Created by Nisse Bergman on 2022-11-27.
//

import Foundation

enum PluralCase: CaseIterable, Equatable {
    case zero
    case one //(singular)
    case two // (dual)
    case few // (paucal)
    case many // (also for fractions if they have a separate form)
    case other // general plural form and used for lanugages that only have one form
}
