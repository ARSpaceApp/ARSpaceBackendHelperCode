//  UserAvatar.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor
import Fluent

public extension FieldKey {
    // Keys for Avatar
    static var avatarId:            Self    { "avatarId" }
    static var avatarEtag:          Self    { "avatarEtag" } // Depricate
    static var avatarLink:          Self    { "avatarLink" }
    static var avatarAWSS3Key:      Self    { "avatarAWSS3Key" }
    static var avatarLinkTimeStamp: Self    { "avatarLinkTimeStamp" }// Depricate
    static var avatarCreatedAt:     Self    { "avatarCreatedAt" }
    static var avatarUpdateAt:      Self    { "avatarUpdateAt" }
    static var avatarDeleteAt:      Self    { "avatarDeleteAt" }
}

/// Represents the user's avatar on the service
public final class UserAvatar : Model, Content {
    public static let schema = "userAvatars"
    
    @ID        (custom: FieldKey.avatarId, generatedBy: .database) public var id:                  Int?
    @Field     (key: FieldKey.avatarLink)                          public var avatarLink:          String
    @Field     (key: FieldKey.avatarAWSS3Key)                      public var avatarAWSS3Key:      String
    @Timestamp (key: FieldKey.avatarCreatedAt, on: .create)        public var avatarCreatedAt:     Date?
    @Timestamp (key: FieldKey.avatarUpdateAt, on: .update)         public var avatarUpdateAt:      Date?
    @Timestamp (key: FieldKey.avatarDeleteAt, on: .delete)         public var avatarDeleteAt:      Date?
    @Parent    (key: FieldKey.user_id)                             public var user:                User

    public init () {}
    
    public init(id: Int? = nil, avatarLink: String, avatarAWSS3Key: String, user: User) {
        self.avatarLink = avatarLink
        self.avatarAWSS3Key = avatarAWSS3Key
        self.$user.id = user.id!
    }
    
    public func makeAvatarResponse() -> UserAvatarOutput {
        return UserAvatarOutput(id: self.id!, directLink: self.avatarLink, createAt: self.avatarCreatedAt, updateAt: self.avatarUpdateAt, deleteAt: self.avatarDeleteAt)
    }
}
