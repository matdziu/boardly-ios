//
//  StringExtensions.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 09/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

extension String {
    
    func isOfType(type: String) -> Bool {
        return contains(type)
    }
    
    func clearFromType(type: String) -> String {
        return replacingOccurrences(of: type, with: "")
    }
    
    func safelyLimitedTo(length n: Int) -> String {
        if (self.count <= n) {
            return self
        }
        return String(Array(self).prefix(upTo: n))
    }
    
    func noSpecialChars() -> String {
        return replacingOccurrences(of: "ą", with: "a")
            .replacingOccurrences(of: "ę", with: "e")
            .replacingOccurrences(of: "ć", with: "c")
            .replacingOccurrences(of: "ł", with: "l")
            .replacingOccurrences(of: "ń", with: "n")
            .replacingOccurrences(of: "ó", with: "o")
            .replacingOccurrences(of: "ś", with: "s")
            .replacingOccurrences(of: "ź", with: "z")
            .replacingOccurrences(of: "ż", with: "z")
    }
}
