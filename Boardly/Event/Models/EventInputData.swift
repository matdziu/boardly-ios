//
//  EventInputData.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 04/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct EventInputData {
    var eventId: String = ""
    var eventName: String = ""
    var description: String = ""
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
    var placeLatitude: Double = 0.0
    var placeLongitude: Double = 0.0
    var levelId: String = ""
    var timestamp: UInt64 = 0
    var adminId: String = ""
    
    func toDict() -> [String: Any] {
        return ["eventName" : eventName,
                "description" : description,
                "gameName" : gameName,
                "gameId" : gameId,
                "gameName2" : gameName2,
                "gameId2" : gameId2,
                "gameName3" : gameName3,
                "gameId3" : gameId3,
                "gameImageUrl" : gameImageUrl,
                "gameImageUrl2" : gameImageUrl2,
                "gameImageUrl3" : gameImageUrl3,
                "placeName" : placeName,
                "placeLatitude" : placeLatitude,
                "placeLongitude" : placeLongitude,
                "levelId" : levelId,
                "timestamp" : timestamp,
                "adminId" : adminId]
    }
}
