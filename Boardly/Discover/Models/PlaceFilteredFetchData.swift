//
//  PlaceFilteredFetchData.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct PlaceFilteredFetchData {
    var userLocation: UserLocation
    var radius: Double = 50.0
    
    init(userLocation: UserLocation,
         radius: Double = 50.0) {
        self.userLocation = userLocation
        self.radius = radius
    }
}
