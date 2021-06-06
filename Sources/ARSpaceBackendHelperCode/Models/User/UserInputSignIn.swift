//  UserInputSignIn.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor

/// Used to sign in a registered user to service.
public struct UserInputSignIn : Content {
    public let username: String
    public let password: String
    
    public init (username: String, password: String) {
        self.username = username
        self.password = password
    }
}

extension UserInputSignIn : Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("username", as: String.self, is: !.empty, required: true)
        validations.add("password", as: String.self, is: !.empty, required: true)
    }
}
