//  RegexName.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor
import Fluent

public enum RegexName: String, Codable, CaseIterable, Content  {
    public static var name: FieldKey { .regexName }
    case usernameRegex, passwordRegex, emailRegex
}
