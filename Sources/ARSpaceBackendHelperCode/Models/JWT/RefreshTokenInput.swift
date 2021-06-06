//  RefreshTokenInput.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor

public struct RefreshTokenInput: Content {
    public let refreshToken: String
}
