//
//  PickGameViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 31/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct PickGameViewState: Equatable {
    
    var progress: Bool = false
    var searchResults: [SearchResult] = []
    var error: NSError? = nil
    var unacceptedQuery: String = ""
    
    init(progress: Bool = false,
         searchResults: [SearchResult] = [],
         error: NSError? = nil,
         unacceptedQuery: String = "") {
        self.progress = progress
        self.searchResults = searchResults
        self.error = error
        self.unacceptedQuery = unacceptedQuery
    }
}
