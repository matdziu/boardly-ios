//
//  PartialNotifyViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 24/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

enum PartialNotifyViewState: Equatable {
    case gameDetailsFetched(game: Game)
    case notifySettingsFetched(notifySettings: NotifySettings)
    case placePicked
    case localValidation(selectedPlaceValid: Bool)
    case progress
    case success
    
    func reduce(previousState: NotifyViewState) -> NotifyViewState {
        switch self {
        case .gameDetailsFetched(let game):
            var newState = previousState
            newState.gameImageUrl = game.image
            return newState
        case .notifySettingsFetched(let notifySettings):
            var newState = previousState
            newState.progress = false
            newState.notifySettings = notifySettings
            return newState
        case .placePicked:
            var newState = previousState
            newState.selectedPlaceValid = true
            return newState
        case .localValidation(let selectedPlaceValid):
            var newState = previousState
            newState.selectedPlaceValid = selectedPlaceValid
            return newState
        case .progress:
            var newState = previousState
            newState.progress = true
            return newState
        case .success:
            return NotifyViewState(success: true)
        }
    }
}
