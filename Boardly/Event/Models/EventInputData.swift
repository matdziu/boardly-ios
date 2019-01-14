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
    var timestamp: Int64 = 0
    var adminId: String = ""
    
    init(eventId: String = "",
         eventName: String = "",
         description: String = "",
         gameName: String = "",
         gameId: String = "",
         gameName2: String = "",
         gameId2: String = "",
         gameName3: String = "",
         gameId3: String = "",
         gameImageUrl: String = "",
         gameImageUrl2: String = "",
         gameImageUrl3: String = "",
         placeName: String = "",
         placeLatitude: Double = 0.0,
         placeLongitude: Double = 0.0,
         timestamp: Int64 = 0,
         adminId: String = "") {
        self.eventId = eventId
        self.eventName = eventName
        self.description = description
        self.gameName = gameName
        self.gameId = gameId
        self.gameName2 = gameName2
        self.gameId2 = gameId2
        self.gameName3 = gameName3
        self.gameId3 = gameId3
        self.gameImageUrl = gameImageUrl
        self.gameImageUrl2 = gameImageUrl2
        self.gameImageUrl3 = gameImageUrl3
        self.placeName = placeName
        self.placeLatitude = placeLatitude
        self.placeLongitude = placeLongitude
        self.timestamp = timestamp
        self.adminId = adminId
    }
    
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
                "timestamp" : timestamp,
                "adminId" : adminId]
    }
}
