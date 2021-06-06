//  AWSCredentials.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Foundation

public struct AWSCredentials {
    public let awsAccessKeyID: String
    public let awsSecretAccessKey: String
    
    public init(awsAccessKeyID: String, awsSecretAccessKey: String) {
        self.awsAccessKeyID = awsAccessKeyID
        self.awsSecretAccessKey = awsSecretAccessKey
    }
}
