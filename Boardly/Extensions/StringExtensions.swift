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
}
