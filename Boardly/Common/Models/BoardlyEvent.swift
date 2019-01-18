//
//  Event.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 02/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import FirebaseDatabase

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
    
    init(eventId: String = "",
         eventName: String = "",
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
         timestamp: Int64 = 0,
         description: String = "",
         placeLatitude: Double = 0.0,
         placeLongitude: Double = 0.0,
         adminId: String = "",
         type: EventType = EventType.DEFAULT) {
        self.eventId = eventId
        self.eventName = eventName
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
        self.timestamp = timestamp
        self.description = description
        self.placeLatitude = placeLatitude
        self.placeLongitude = placeLongitude
        self.adminId = adminId
        self.type = type
    }
    
    init(snapshot: DataSnapshot) {
        let value = snapshot.value as? [String : Any] ?? [:]
        self.eventId = snapshot.key
        self.eventName = value["eventName"] as? String ?? ""
        self.gameName = value["gameName"] as? String ?? ""
        self.gameId = value["gameId"] as? String ?? ""
        self.gameName2 = value["gameName2"] as? String ?? ""
        self.gameId2 = value["gameId2"] as? String ?? ""
        self.gameName3 = value["gameName3"] as? String ?? ""
        self.gameId3 = value["gameId3"] as? String ?? ""
        self.gameImageUrl = value["gameImageUrl"] as? String ?? ""
        self.gameImageUrl2 = value["gameImageUrl2"] as? String ?? ""
        self.gameImageUrl3 = value["gameImageUrl3"] as? String ?? ""
        self.placeName = value["placeName"] as? String ?? ""
        self.timestamp = value["timestamp"] as? Int64 ?? 0
        self.description = value["description"] as? String ?? ""
        self.placeLatitude = value["placeLatitude"] as? Double ?? 0.0
        self.placeLongitude = value["placeLongitude"] as? Double ?? 0.0
        self.adminId = value["adminId"] as? String ?? ""
    }
}

enum EventType {
    case CREATED, ACCEPTED, PENDING, DEFAULT
}
