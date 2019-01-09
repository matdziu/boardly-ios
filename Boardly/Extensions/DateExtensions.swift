//
//  DateExtensions.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 02/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

extension Date {
    
    func toMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
