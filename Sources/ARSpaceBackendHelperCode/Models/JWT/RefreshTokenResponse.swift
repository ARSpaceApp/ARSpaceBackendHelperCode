//  RefreshTokenResponse.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor

public struct RefreshTokenResponse: Content {
    public let accessToken: String
    public let refreshToken: String
}
