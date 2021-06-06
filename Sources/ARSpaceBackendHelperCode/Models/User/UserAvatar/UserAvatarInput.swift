//  UserAvatarInput.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor

/// Used to send data to server when publishing a user's avatar.
public struct UserAvatarInput : Content {
    public let data: Data
    
    public init (data: Data) {
        self.data = data
    }
}

extension UserAvatarInput : Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("data",
                        as: Data.self,
                        is: !.empty,
                        required: true
        )
    }
}
