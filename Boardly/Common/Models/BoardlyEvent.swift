//
//  Event.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 02/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct BoardlyEvent: Equatable {
    var eventId: String = ""
    var eventName: String = ""
    var gameName: String = ""
    var gameId: String = ""
    var gameName2: String = ""
    var gameId2: String = ""
    var gameName3: String = ""
    var gameId3: String = ""
    var gameImageUrl: String = ""
    var gameImageUrl2: String = ""
    var gameImageUrl3: String = ""
    var placeName: String = ""
    var timestamp: Int64 = 0
    var description: String = ""
    var placeLatitude: Double = 0.0
    var placeLongitude: Double = 0.0
    var adminId: String = ""
    var type: EventType = EventType.DEFAULT
}

enum EventType {
    case CREATED, ACCEPTED, PENDING, DEFAULT
}
