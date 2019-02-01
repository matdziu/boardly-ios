//
//  Player.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Player: Equatable {
    
    var id: String = ""
    var name: String = ""
    var profilePicture: String = ""
    var rating: Double? = nil
    var helloText: String = ""
    var ratedOrSelf: Bool = false
    var eventId: String = ""
    
    init(id: String = "",
         name: String = "",
         profilePicture: String = "",
         rating: Double? = nil,
         helloText: String = "",
         ratedOrSelf: Bool = false,
         eventId: String = "") {
        self.id = id
        self.name = name
        self.profilePicture = profilePicture
        self.rating = rating
        self.helloText = helloText
        self.ratedOrSelf = ratedOrSelf
        self.eventId = eventId
    }
    
    init(snapshot: DataSnapshot) {
        let value = snapshot.value as? [String : Any] ?? [:]
        self.id = value["id"] as? String ?? ""
        self.name = value["name"] as? String ?? ""
        self.profilePicture = value["profilePicture"] as? String ?? ""
        self.rating = value["rating"] as? Double ?? nil
        self.helloText = value["helloText"] as? String ?? ""
        self.ratedOrSelf = value["ratedOrSelf"] as? Bool ?? false
        self.eventId = value["eventId"] as? String ?? ""
    }
}
