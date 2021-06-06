//  AppleUserInput.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor

public struct AppleUserInput: Codable {
    public let appleUserString: String
    public let appleUserFirstName: String?
    public let appleUserLastName: String?
    public let appleUserEmail: String?
}

extension AppleUserInput : Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("appleUserString", as: String.self, is: !.empty, required: true)
    }
}
