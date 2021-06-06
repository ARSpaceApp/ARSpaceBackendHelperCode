//  Request + Ext.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Vapor
import JWT

public extension Request {
    var payload: Payload {
        get {
            self.route?.userInfo[.payload] as! Payload
        }
        set {
            self.route?.userInfo[.payload] = newValue
        }
    }
}
