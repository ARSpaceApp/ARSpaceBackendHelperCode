//  NSRegularExpression + Ext.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Foundation

public extension NSRegularExpression {
    /// Initializes a regular expression from a string pattern
    /// - Parameter pattern: String pattern for the regular expression.
    convenience init(_ pattern: String) throws {
        do {
            try self.init(pattern: pattern)
        } catch {
            throw NSError(domain: "SwiftHelperCode", code: 0, userInfo: ["Invalid regex pattern" : "\(pattern)"])
        }
    }
    
    /// Checks a string against a regular expression.
    /// - Parameter string: Input string to check.
    /// - Returns:  Result of check as a boolean flag.
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
