//
//  DiscoverViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct DiscoverViewState: Equatable {
    var progress: Bool = false
    var placesList: [BoardlyPlace] = []
    
    init(progress: Bool = true,
         placesList: [BoardlyPlace] = []) {
        self.progress = progress
        self.placesList = placesList
    }
}
