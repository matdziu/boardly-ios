//
//  NotifySettings.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 24/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct NotifySettings: Equatable {
    
    var radius: Double = 50.0
    var gameId: String = ""
    var gameName: String = ""
    var userLatitude: Double? = nil
    var userLongitude: Double? = nil
    var locationName: String = ""
    
    init(radius: Double = 50.0,
         gameId: String = "",
         gameName: String = "",
         userLatitude: Double? = nil,
         userLongitude: Double? = nil,
         locationName: String = "") {
        self.radius = radius
        self.gameId = gameId
        self.gameName = gameName
        self.userLatitude = userLatitude
        self.userLongitude = userLongitude
        self.locationName = locationName
    }
    
    init(snapshot: DataSnapshot) {
        let value = snapshot.value as? [String : Any] ?? [:]
        self.radius = value["radius"] as? Double ?? 50.0
        self.gameId = value["gameId"] as? String ?? ""
        self.gameName = value["gameName"] as? String ?? ""
        self.userLatitude = value["userLatitude"] as? Double
        self.userLongitude = value["userLongitude"] as? Double
        self.locationName = value["locationName"] as? String ?? ""
    }
    
    func toDict() -> [String : Any?] {
        return ["radius": radius,
                "gameId": gameId,
                "gameName": gameName,
                "userLatitude": userLatitude,
                "userLongitude": userLongitude,
                "locationName": locationName]
    }
}
