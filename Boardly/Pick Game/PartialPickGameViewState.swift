//
//  PartialPickGameViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 31/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation

enum PartialPickGameViewState: Equatable {
    case progress
    case resultsFetched(searchResults: [SearchResult])
    case errorState(error: NSError, unacceptedQuery: String)
    
    func reduce(previousState: PickGameViewState) -> PickGameViewState {
        switch self {
        case .progress:
            return PickGameViewState(progress: true)
        case .resultsFetched(let searchResults):
            return PickGameViewState(searchResults: searchResults)
        case .errorState(let error, let unacceptedQuery):
            return PickGameViewState(error: error, unacceptedQuery: unacceptedQuery)
        }
    }
}
