//  AppleUser.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor
import Fluent

/// Keys for AppleUser
public extension FieldKey {
    static var appleUserId:         Self    {"appleUserId"}
    static var appleUserString:     Self    {"appleUserString"}
    static var appleUserFirstName:  Self    {"appleUserFirstName"}
    static var appleUserLastName:   Self    {"appleUserLastName"}
    static var appleUserUsername:   Self    {"appleUserUsername"}
    static var appleUserEmail:      Self    {"appleUserEmail"}
    static var appleUserCreatedAt:  Self    {"appleUserCreatedAt"}
    static var appleUserUpdateAt:   Self    {"appleUserUpdateAt"}
    static var appleUserDeleteAt:   Self    {"appleUserDeleteAt"}
}

public final class AppleUser :  Model, Content {
    public static let schema = "appleUsers"
    
    @ID             (custom: FieldKey.appleUserId, generatedBy: .database) public var id:                 Int?
    @Field          (key: FieldKey.appleUserString)                        public var appleUserString:    String
    @OptionalField  (key: FieldKey.appleUserFirstName)                     public var appleUserFirstName: String?
    @OptionalField  (key: FieldKey.appleUserLastName)                      public var appleUserLastName:  String?
    @Field          (key: FieldKey.appleUserUsername)                      public var appleUserUsername:  String
    @OptionalField  (key: FieldKey.appleUserEmail)                         public var appleUserEmail:     String?
    @Timestamp      (key: FieldKey.appleUserCreatedAt, on: .create)        public var appleUserCreatedAt: Date?
    @Timestamp      (key: FieldKey.appleUserUpdateAt, on: .update)         public var appleUserUpdateAt:  Date?
    @Timestamp      (key: FieldKey.appleUserDeleteAt, on: .delete)         public var appleUserDeleteAt:  Date?
    @Parent         (key: FieldKey.user_id)                                public var user:               User
    
    public init () {}
    
    public init (id: Int? = nil, appleUserInput: AppleUserInput, userName: String) {
        self.appleUserString = appleUserInput.appleUserString
        self.appleUserFirstName = appleUserInput.appleUserFirstName
        self.appleUserLastName = appleUserInput.appleUserLastName
        self.appleUserEmail = appleUserInput.appleUserEmail
        self.appleUserUsername = userName
    }
}
