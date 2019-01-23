//
//  Utils.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 02/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

let DAY_IN_MILLIS = 24 * 60 * 60 * 1000
let HOUR_IN_MILLIS = 1 * 60 * 60 * 1000

func isOlderThanOneDay(timestamp: Int64) -> Bool {
    let now = Date().toMillis()
    return (now - timestamp) > DAY_IN_MILLIS && timestamp != 0
}
