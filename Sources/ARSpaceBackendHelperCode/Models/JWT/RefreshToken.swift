//  RefreshToken.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Foundation
import JWT

public struct RefreshToken: JWTPayload {
    public let id: Int
    public let iat: TimeInterval
    public let exp: TimeInterval
    
    public init(user: User) {
        let lifeTime = Date.createNewDate(originalDate: Date(), byAdding: AppValues.refreshTokenLifeTime.component, number: AppValues.refreshTokenLifeTime.value)
        self.id = user.id ?? 0
        self.iat = Date().timeIntervalSinceNow
        self.exp = lifeTime!.timeIntervalSince1970

    }
    public func verify(using signer: JWTSigner) throws {
        let expiration = Date(timeIntervalSince1970: self.exp)
        try ExpirationClaim(value: expiration).verifyNotExpired() }
}
