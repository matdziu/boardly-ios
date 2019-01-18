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
