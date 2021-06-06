//  Payload.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import JWT
import Vapor

/// JWT payload structure.
public struct Payload: JWTPayload {
    public enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case id = "id"
        case username = "username"
        //case userRights = "rights"
        //case userStatus = "status"
    }

    // The "sub" (subject) claim identifies the principal that is the
    // subject of the JWT.
    public var subject: SubjectClaim

    // The "exp" (expiration time) claim identifies the expiration time on
    // or after which the JWT MUST NOT be accepted for processing.
    public var expiration: ExpirationClaim

    // Custom data
    public var id: Int?
    public var username: String?
    //var userRights: UserRights
    //var userStatus: Status

    // Run any additional verification logic beyond signature verification here.
    // Since we have an ExpirationClaim, we will call its verify method.
    public func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}

public extension AnyHashable {
    static let payload: String = "jwt_payload"
}

