//  UserAddressInput.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor

public struct UserAddressInput: Content {
    public let address : String
    public let city    : String
    public let region  : String
    public let country : String
    public let zip     : String
    
    public init (address: String, city: String,region: String,country: String, zip: String) {
        self.address = address
        self.city    = city
        self.region  = region
        self.country = country
        self.zip     = zip
    }
    
    public func makeAddress(for user: User) -> UserAddress {
        return UserAddress(address: self.address, city: self.city, region: self.region, country: self.country, zip: self.zip, user: user)
    }
}
