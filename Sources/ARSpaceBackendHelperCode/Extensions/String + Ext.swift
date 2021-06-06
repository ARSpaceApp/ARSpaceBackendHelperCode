//  String + Ext.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Foundation

public extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func translateToLatin(nonLatin: String, spaceReplacementCharacter: String) -> String {
        let mut = NSMutableString(string: nonLatin) as CFMutableString
        CFStringTransform(mut, nil, "Any-Latin; Latin-ASCII; Any-Lower;" as CFString, false)
        return (mut as String).replacingOccurrences(of: " ", with: spaceReplacementCharacter)
    }
}

