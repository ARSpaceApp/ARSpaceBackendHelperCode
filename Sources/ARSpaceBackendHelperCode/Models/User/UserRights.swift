//  UserRights.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor
import Fluent

public struct UserRights: OptionSet, Codable, CustomStringConvertible, Hashable {
    
    public init(rawValue: Int64) {
        self.rawValue = rawValue
    }
    
    public init(from decoder: Decoder) throws {
      rawValue = try .init(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
      try rawValue.encode(to: encoder)
    }
    
    public let rawValue: Int64

    public static let user: Self = []
    public static let admin = Self(rawValue: 1 << 1)
    public static let superAdmin = Self(rawValue: 1 << 0)
    
    public static let rightsArray = [user, admin, superAdmin]

    public var description: String {
        var vals = [String]()
//        if self.contains(.user) {
//            vals.append("user")
//        }
        if self.contains(.admin) {
            vals.append("admin")
        }
        if self.contains(.superAdmin) {
            vals.append("superAdmin")
        }
        
        return vals.joined(separator: ",")
    }

    /// Returns numeric range of all valid groups.
    /// - Returns: numeric range of all valid groups as ClosedRange of Int64.
    public static func groupRange() -> ClosedRange<Int64> {
        let minUserRightsValue = rightsArray.min { a, b in a.rawValue < b.rawValue }
        let maxUserRightsValue = rightsArray.max { a, b in a.rawValue < b.rawValue }
        return minUserRightsValue!.rawValue...maxUserRightsValue!.rawValue
    }
    
    /// Checks if user with specified role ID is in super administrator or administrator role.
    /// - Parameter roleID: Role identifier.
    /// - Throws: Role identifier error is out of range.
    /// - Returns: Error message or boolean flag of check result.
    public static func userIsAnAdmin (roleID: Int64) throws -> Bool {
        if groupRange().contains(roleID) {
            return roleID == superAdmin.rawValue || roleID == admin.rawValue ? true : false
        } else {
            throw Abort (.badRequest, reason: "Invalid role identifier '\(roleID)' specified for user.")
        }
    }
    
    /// Searches for user rights by role ID.
    /// - Parameter roleID: Role identifier.
    /// - Throws: Role identifier error is out of range.
    /// - Returns: Error message or found permissions for user.
    public static func getUserRightsBy(roleID: Int64) throws -> UserRights {
        if groupRange().contains(roleID), let userRights = rightsArray.first(where: {$0.rawValue == roleID}) {
            return userRights
        } else {
            throw Abort (.badRequest, reason: "Invalid role identifier '\(roleID)' specified for user.")
        }
    }
}
