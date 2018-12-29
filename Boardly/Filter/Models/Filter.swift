//
//  Filter.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 29/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct Filter {
    var radius: Double = 50.0
    var gameId: String = ""
    var gameName: String = ""
    var userLocation: UserLocation? = nil
    var locationName: String = ""
    var isCurrentLocation: Bool = true
}
