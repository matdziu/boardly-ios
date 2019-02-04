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

func mapToRatedAllWhere(_ predicate: (Player) -> Bool, in playersList: [Player]) -> [Player] {
    return playersList.map {
        if predicate($0) {
            var newPlayer = $0
            newPlayer.ratedOrSelf = true
            return newPlayer
        } else {
            return $0
        }
    }
}

func getCurrentISODate() -> String {
    let dateFormatter = DateFormatter()
    let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
    dateFormatter.locale = enUSPosixLocale
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return dateFormatter.string(from: Date())
}
