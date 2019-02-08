//
//  PartialPickPlaceViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 08/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

enum PartialPickPlaceViewState: Equatable {
    
    case progress
    case resultsFetched(searchResults: [PlaceSearchResult])
    case errorState(error: NSError)
    
    func reduce(previousState: PickPlaceViewState) -> PickPlaceViewState {
        switch self {
        case .progress:
            return PickPlaceViewState(progress: true)
        case .resultsFetched(let searchResults):
            return PickPlaceViewState(searchResults: searchResults)
        case .errorState(let error):
            return PickPlaceViewState(error: error)
        }
    }
}
