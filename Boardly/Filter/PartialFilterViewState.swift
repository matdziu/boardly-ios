//
//  PartialFilterViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 29/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation

enum PartialFilterViewState : Equatable {
    case gameDetailsFetched(game: Game)
    case locationProcessingState(processing: Bool)
    
    func reduce(previousState: FilterViewState) -> FilterViewState {
        switch self {
        case .gameDetailsFetched(let game):
            return FilterViewState(gameImageUrl: game.image)
        case .locationProcessingState(let processing):
            var newState = previousState
            newState.locationProcessing = processing
            return newState
        }
    }
}
