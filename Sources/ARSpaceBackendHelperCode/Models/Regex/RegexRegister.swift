//  RegexRegister.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor

/// Represents entity of regular expression as value accepted by query to register with DB.
public struct RegexRegister: Content {
    public var regexname    : String
    public var description  : String
    public var regexString  : String
    public var rule         : String
    
    public init (regexname: String, description: String, regexString: String, rule: String) {
        self.regexname      = regexname
        self.description    = description
        self.regexString    = regexString
        self.rule           = rule
    }
}

extension RegexRegister : Validatable {
    public static func validations(_ validations: inout Validations) {
        
        validations.add("regexname", as: String.self,
                        is: .in(RegexName.usernameRegex.rawValue,RegexName.passwordRegex.rawValue, RegexName.emailRegex.rawValue),
                        required: true
        )

        validations.add("description", as: String.self,
                        is: !.empty,
                        required: true)
        
        validations.add("regexString",
                        as: String.self,
                        is: !.empty)

        validations.add("rule", as: String.self,
                        is: !.empty,
                        required: true)
    }
    
    public func makeUserRegex() -> UserRegex {
        let regexName = RegexName.allCases.first(where: {$0.rawValue == self.regexname})
        
        
        return UserRegex(
            regexName: regexName!,
            description: self.description,
            regexString: self.regexString,
            rule: self.rule)
    }
}
