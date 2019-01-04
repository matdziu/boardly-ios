//
//  PartialEventViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 04/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

enum PartialEventViewState: Equatable {
    case progress
    case gameDetailsFetched(game: Game, gamePickType: GamePickType)
    case gamePickedState
    case placePickedState
    case localValidation(eventNameValid: Bool, selectedGameValid: Bool, selectedPlaceValid: Bool)
    case successState
    case removedState
    
    func reduce(previousState: EventViewState) -> EventViewState {
        switch self {
        case .progress:
            var newState = previousState
            newState.progress = true
            return newState
        case .gameDetailsFetched(let game, let gamePickType):
            var newState = previousState
            switch gamePickType {
            case .first:
                newState.selectedGame = game
                return newState
            case .second:
                newState.selectedGame2 = game
                return newState
            case .third:
                newState.selectedGame3 = game
                return newState
            }
        case .gamePickedState:
            var newState = previousState
            newState.selectedGameValid = true
            return newState
        case .placePickedState:
            var newState = previousState
            newState.selectedPlaceValid = true
            return newState
        case .localValidation(let eventNameValid, let selectedGameValid, let selectedPlaceValid):
            var newState = previousState
            newState.eventNameValid = eventNameValid
            newState.selectedGameValid = selectedGameValid
            newState.selectedPlaceValid = selectedPlaceValid
            return newState
        case .successState:
            return EventViewState(success: true, selectedGame: previousState.selectedGame)
        case .removedState:
            return EventViewState(removed: true)
        }
    }
}
