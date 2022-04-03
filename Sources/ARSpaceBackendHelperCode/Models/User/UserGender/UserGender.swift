//  UserGender.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor

public protocol Option: RawRepresentable, Hashable, CaseIterable, Content {}

/// Defines gender of user.
public enum UserGender: String, Option {
    case male, female
}

public extension Set where Element == UserGender {
    static var male: Set<UserGender> {
        return [.male]
    }

    static var female: Set<UserGender> {
        return [.female]
    }

    static var all: UserGenders {
        return Set(Element.allCases)
    }
}

public extension Set where Element: Option {
    var rawValue: Int {
        var rawValue = 0
        for (index, element) in Element.allCases.enumerated() {
            if self.contains(element) {
                rawValue |= (1 << index)
            }
        }
        return rawValue
    }
}

public extension UserGender {
    var description : String {
        switch self {
        case .male:
            return "male"
        case .female:
            return "female"
        }
    }
}

public typealias UserGenders  = Set<UserGender>
