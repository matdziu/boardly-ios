//
//  PartialDiscoverViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

enum PartialDiscoverViewState: Equatable {
    case placesListFetched(placesList: [BoardlyPlace])
    
    func reduce(previousState: DiscoverViewState) -> DiscoverViewState {
        switch self {
        case .placesListFetched(let placesList):
            return DiscoverViewState(
                progress: false,
                placesList: placesList)
        }
    }
}
