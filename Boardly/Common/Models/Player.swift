//
//  Player.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

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
}
