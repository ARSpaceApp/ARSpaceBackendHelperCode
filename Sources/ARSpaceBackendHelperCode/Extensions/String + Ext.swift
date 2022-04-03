//  String + Ext.swift
//  Created by Dmitry Samartcev on 06.06.2021.

import Foundation
import CoreFoundation

public extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func translateToLatin(nonLatin: String, spaceReplacementCharacter: String) -> String {
        
//        guard let mut = NSMutableString(string: nonLatin) as? CFMutableString else {
//            return nonLatin
//        }
//
//        CFStringTransform(mut, nil, "Any-Latin; Latin-ASCII; Any-Lower;" as! CFString, false)
//
//        guard let resultString =  mut as? String else {
//            return nonLatin
//        }
        
        
        //return resultString.replacingOccurrences(of: " ", with: spaceReplacementCharacter)
        
        return nonLatin
    }
}

