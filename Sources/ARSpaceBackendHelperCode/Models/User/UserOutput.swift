//  UserOutput.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor

/// Used to respond to a server request for an existing user.
public struct UserOutput: Content {
    public let id        : Int?
    public let username  : String?
    public let firstname : String?
    public let lastname  : String?
    public let gender    : UserGender?
    public let dob       : Date?
    public let age       : Int?
    public let email     : String
    public let avatars   : [UserAvatarOutput]?
    public let addresses : [UserAddressOutput]?
    public let createAt  : Date?
    public let updateAt  : Date?
    public let deleteAt  : Date?
    
    public init (id: Int? = nil, username: String? = nil, firstname: String? = nil, lastname: String? = nil, gender: UserGender? = nil, dob: Date? = nil, age: Int? = nil, email: String, avatars: [UserAvatarOutput]? = nil, addresses : [UserAddressOutput]? = nil, createAt: Date? = nil, updateAt: Date? = nil, deleteAt: Date? = nil){
        self.id = id
        self.username = username
        self.firstname = firstname
        self.lastname = lastname
        self.gender = gender
        self.dob = dob
        self.age = age
        self.email = email
        self.avatars = avatars
        self.addresses = addresses
        self.createAt = createAt
        self.updateAt = updateAt
        self.deleteAt = deleteAt
    }
    
    public init (user: User) {
        
        var existingAvatars: [UserAvatarOutput] = .init()
        for avatar in user.avatars {
            if let output = UserAvatarOutput(avatar: avatar) {
                existingAvatars.append(output)
            }
        }
        
        var existingAddresses: [UserAddressOutput] = .init()
        for address in user.addresses {
            existingAddresses.append(UserAddressOutput(address: address))
        }

        self.id = user.id
        self.username = user.username
        self.firstname = user.firstname
        self.lastname = user.lastname
        self.gender = user.gender
        self.dob = user.dob
        self.age = user.age
        self.email = user.email ?? ""
        self.avatars = existingAvatars
        self.addresses = existingAddresses
        self.createAt = user.createdAt
        self.updateAt = user.updatedAt
        self.deleteAt = user.deleteAt
    }
}
