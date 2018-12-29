//
//  FilterViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 29/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct FilterViewState : Equatable {
    
    var gameImageUrl: String = ""
    var locationProcessing: Bool = false
    
    init(gameImageUrl: String = "",
         locationProcessing: Bool = false) {
        self.gameImageUrl = gameImageUrl
        self.locationProcessing = locationProcessing
    }
}
