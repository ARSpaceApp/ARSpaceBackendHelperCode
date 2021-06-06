//  UserAddressOutput.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor

/// Used to respond to a server request for an existing address.
public struct UserAddressOutput : Content {
    public let address  : String
    public let city     : String
    public let region   : String
    public let country  : String
    public let zip      : String
    public let createAt : Date?
    public let updateAt : Date?
    public let deleteAt : Date?
    
    public init (address: String, city: String,region: String, country: String, zip: String, createAt: Date? = nil, updateAt: Date? = nil, deleteAt: Date? = nil) {
        self.address  = address
        self.city     = city
        self.region   = region
        self.country  = country
        self.zip      = zip
        self.createAt = createAt
        self.updateAt = updateAt
        self.deleteAt = deleteAt
    }
    
    public init(address: UserAddress) {
        self.address  = address.addressAddress
        self.city     = address.addressCity
        self.region   = address.addressRegion
        self.country  = address.addressCountry
        self.zip      = address.addressZip
        self.createAt = address.addressCreateAt
        self.updateAt = address.addressUpdateAt
        self.deleteAt = address.addressDeleteAt
    }
}
