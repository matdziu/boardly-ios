//
//  PickPlaceViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 08/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct PickPlaceViewState: Equatable {
    
    var progress: Bool = false
    var searchResults: [PlaceSearchResult] = []
    var error: NSError? = nil
    
    init(progress: Bool = false,
         searchResults: [PlaceSearchResult] = [],
         error: NSError? = nil) {
        self.progress = progress
        self.searchResults = searchResults
        self.error = error
    }
}
