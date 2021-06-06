//  User.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor
import Fluent

/// Keys for User
public extension FieldKey {
    static var userId:          Self    { "userId" }
    static var username:        Self    { "username" }
    static var firstname:       Self    { "firstname" }
    static var lastname:        Self    { "lastname" }
    static var email:           Self    { "email" }
    static var password_hash:   Self    { "password_hash" }
    static var gender:          Self    { "gender" }
    static var dob:             Self    { "dob" }
    static var age:             Self    { "age" }
    static var avatars:         Self    { "avatars" }
    static var addresses:       Self    { "addresses" }
    static var appleUser:       Self    { "appleUser" }
    static var userCreatedAt:   Self    { "userCreatedAt" }
    static var userUpdateAt:    Self    { "userUpdateAt" }
    static var userDeleteAt:    Self    { "userDeleteAt" }
}

public final class User: Model, Content {
    
    public static let schema = "users"

    @ID            (custom: FieldKey.userId, generatedBy: .database) public var id:            Int?
    @OptionalField (key: FieldKey.username)                          public var username:      String?
    @OptionalField (key: FieldKey.firstname)                         public var firstname:     String?
    @OptionalField (key: FieldKey.lastname)                          public var lastname:      String?
    @OptionalField (key: FieldKey.email)                             public var email:         String?
    @OptionalField (key: FieldKey.password_hash)                     public var password_hash: String?
    @OptionalField (key: FieldKey.gender)                            public var gender:        UserGender?
    @OptionalField (key: FieldKey.dob)                               public var dob:           Date?
    @OptionalField (key: FieldKey.age)                               public var age:           Int?
    @Children      (for: \.$user)                                    public var avatars:       [UserAvatar]
    @Children      (for: \.$user)                                    public var addresses:     [UserAddress]
    @Children      (for: \.$user)                                    public var appleUser:     [AppleUser]
    @Timestamp     (key: FieldKey.userCreatedAt, on: .create)        public var createdAt:     Date?
    @Timestamp     (key: FieldKey.userUpdateAt, on: .update)         public var updatedAt:     Date?
    @Timestamp     (key: FieldKey.userDeleteAt, on: .delete)         public var deleteAt:      Date?
    
    public init () {}
    
    // For direct sign up
    public init(id: Int? = nil, username: String, password: String, email: String) throws {
        self.username = username
        self.password_hash = try BCryptDigest().hash(password)
        self.email = email
    }
    
    // For AppleUser sign up
    public init(id: Int? = nil, appleUser: AppleUser) {
        self.username = appleUser.appleUserUsername
        self.firstname = appleUser.appleUserFirstName
        self.lastname = appleUser.appleUserLastName
        self.email = appleUser.appleUserEmail
        
        self.appleUser.append(appleUser)
    }
    
    public init(id: Int? = nil, username: String?, firstname: String?, lastname: String?, email: String?, password: String?, gender: UserGender?, dob: Date?, avatar: UserAvatar?, address: UserAddress?) throws {
        
        self.username = username ?? nil
        self.firstname = firstname ?? nil
        self.lastname = lastname ?? nil
        self.email = email ?? nil
        
        if let password = password {
            self.password_hash = try BCryptDigest().hash(password)
        }
        
        if let existingGender = gender {
            self.gender = existingGender
        }

        if let dob = dob {
            self.dob = dob
            self.age = Date.differenceBetweenDatesInYears(startDate: dob, endDate: Date())
        }
        
        if let avatar = avatar {
            avatars.append(avatar)
        }
        
        if let address = address {
            self.addresses.append(address)
        }
    }
    
    public func makeUserResponse () -> UserOutput {
        // Find addresses
        var addressesResponses = [UserAddressOutput]()
        if let addressResponse = self.addresses.first?.makeAddressResponse() {
            addressesResponses.append(addressResponse)
        }

        // Find avatars
        var avatarResponses = [UserAvatarOutput]()
        if let avatars =  self.$avatars.value, avatars.count > 0 {
            avatars.forEach {
                avatarResponses.append($0.makeAvatarResponse())
            }
        }

        // Response
        return UserOutput(id: self.id, username: self.username, firstname: self.firstname, lastname: self.lastname, gender: self.gender, dob: self.dob, age: self.age, email: self.email!, avatars: avatarResponses, addresses: addressesResponses, createAt: self.createdAt, updateAt: self.updatedAt, deleteAt: self.deleteAt)
    }
}
