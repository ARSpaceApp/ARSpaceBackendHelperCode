//  UserRegex.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor
import Fluent

public extension FieldKey {
    // Keys for UserRegex
    static var regexId:             Self    { "regexId" }
    static var regexName:           Self    { "regexName" }
    static var regexDescription:    Self    { "regexDescription" }
    static var regexString:         Self    { "regexString" }
    static var regexRule:           Self    { "regexRule" }
    static var regexCreateAt:       Self    { "regexCreateAt" }
    static var regexUpdateAt:       Self    { "regexUpdateAt" }
    static var regexDeleteAt:       Self    { "regexDeleteAt" }
}

public final class UserRegex : Model, Content {
   
    public static let schema = "userRegex"
    
    @ID        (custom: FieldKey.regexId, generatedBy: .database) public var id:               Int?
    @Field     (key: FieldKey.regexName)                          public var regexName:        RegexName
    @Field     (key: FieldKey.regexDescription)                   public var regexDescription: String
    @Field     (key: FieldKey.regexString)                        public var regexString:      String
    @Field     (key: FieldKey.regexRule)                          public var regexRule:        String
    @Timestamp (key: FieldKey.regexCreateAt, on: .create)         public var regexCreateAt:    Date?
    @Timestamp (key: FieldKey.regexUpdateAt, on: .update)         public var regexUpdateAt:    Date?
    @Timestamp (key: FieldKey.regexDeleteAt, on: .delete)         public var regexDeleteAt:    Date?

    public init() {}
    
    public init (id: Int? = nil, regexName: RegexName, description: String, regexString: String, rule: String) {
        self.regexName = regexName
        self.regexDescription = description
        self.regexString = regexString
        self.regexRule = rule
    }
}

