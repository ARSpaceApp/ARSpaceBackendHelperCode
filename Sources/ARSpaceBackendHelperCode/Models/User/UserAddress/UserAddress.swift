//  UserAddress.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor
import Fluent

public extension FieldKey {
    // Keys for Address
    static var addressId:          Self    { "addressId" }
    static var addressAddress:     Self    { "addressAddress" }
    static var addressCity:        Self    { "addressCity" }
    static var addressRegion:      Self    { "addressRegion" }
    static var addressCountry:     Self    { "addressCountry" }
    static var addressZip:         Self    { "addressZip" }
    static var addressCreateAt:    Self    { "addressCreateAt" }
    static var addressUpdateAt:    Self    { "addressUpdateAt" }
    static var addressDeleteAt:    Self    { "addressDeleteAt" }
    static var user_id:            Self    { "user_id" }
}

/// Represents the address (delivery address) of the user on service.
public final class UserAddress : Model, Content {
    
    public static let schema = "userAddresses"
    @ID        (custom: FieldKey.addressId, generatedBy: .database) public var id:               Int?
    @Field     (key: FieldKey.addressAddress)                       public var addressAddress:   String
    @Field     (key: FieldKey.addressCity)                          public var addressCity:      String
    @Field     (key: FieldKey.addressRegion)                        public var addressRegion:    String
    @Field     (key: FieldKey.addressCountry)                       public var addressCountry:   String
    @Field     (key: FieldKey.addressZip)                           public var addressZip:       String
    @Timestamp (key: FieldKey.addressCreateAt, on: .create)         public var addressCreateAt:  Date?
    @Timestamp (key: FieldKey.addressUpdateAt, on: .update)         public var addressUpdateAt:  Date?
    @Timestamp (key: FieldKey.addressDeleteAt, on: .delete)         public var addressDeleteAt:  Date?
    @Parent    (key: FieldKey.user_id)                              public var user:             User
    
    public init() {}
    
    public init (id: Int? = nil, address : String, city : String, region : String, country : String, zip : String, user: User) {
        self.addressAddress = address
        self.addressCity = city
        self.addressRegion = region
        self.addressCountry = country
        self.addressZip = zip
        self.$user.id = user.id!
    }
    
    public func makeAddressResponse() -> UserAddressOutput {
        return UserAddressOutput(address: self.addressAddress, city: self.addressCity, region: self.addressRegion, country: self.addressCountry, zip: self.addressZip, createAt: self.addressCreateAt, updateAt: self.addressUpdateAt, deleteAt: self.addressDeleteAt)
    }
    
}

