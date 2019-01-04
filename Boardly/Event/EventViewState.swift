//
//  EventViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 04/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct EventViewState: Equatable {
    var progress: Bool = false
    var success: Bool = false
    var removed: Bool = false
    var selectedGame: Game = Game()
    var selectedGame2: Game = Game()
    var selectedGame3: Game = Game()
    var eventNameValid: Bool = true
    var selectedGameValid: Bool = true
    var selectedPlaceValid: Bool = true
    
    init(progress: Bool = false,
         success: Bool = false,
         removed: Bool = false,
         selectedGame: Game = Game(),
         selectedGame2: Game = Game(),
         selectedGame3: Game = Game(),
         eventNameValid: Bool = true,
         selectedGameValid: Bool = true,
         selectedPlaceValid: Bool = true) {
        self.progress = progress
        self.success = success
        self.removed = removed
        self.selectedGame = selectedGame
        self.selectedGame2 = selectedGame2
        self.selectedGame3 = selectedGame3
        self.eventNameValid = eventNameValid
        self.selectedGameValid = selectedGameValid
        self.selectedPlaceValid = selectedPlaceValid
    }
}
