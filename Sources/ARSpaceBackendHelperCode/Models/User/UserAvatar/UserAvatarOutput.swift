//  UserAvatarOutput.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor

/// Used to respond to a server request for an existing avatar.
public struct UserAvatarOutput: Content {
    public let id         : Int
    public let directLink : String
    public let createAt   : Date?
    public let updateAt   : Date?
    public let deleteAt   : Date?
    
    public init (id: Int, directLink: String, createAt: Date? = nil, updateAt: Date? = nil, deleteAt: Date? = nil) {
        self.id         = id
        self.directLink = directLink
        self.createAt   = createAt
        self.updateAt   = updateAt
        self.deleteAt   = deleteAt
    }
    
    public init?(avatar: UserAvatar) {
        guard let id = avatar.id else {return nil}
        self.id         = id
        self.directLink = avatar.avatarLink
        self.createAt   = avatar.avatarCreatedAt
        self.updateAt   = avatar.avatarUpdateAt
        self.deleteAt   = avatar.avatarDeleteAt
    }
}
