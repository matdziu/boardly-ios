//
//  NotifyViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 24/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct NotifyViewState: Equatable {
    
    var gameImageUrl: String = ""
    var notifySettings: NotifySettings = NotifySettings()
    var progress: Bool = false
    var selectedPlaceValid: Bool = true
    var success: Bool = false
    
    init(gameImageUrl: String = "",
         notifySettings: NotifySettings = NotifySettings(),
         progress: Bool = false,
         selectedPlaceValid: Bool = true,
         success: Bool = false) {
        self.gameImageUrl = gameImageUrl
        self.notifySettings = notifySettings
        self.progress = progress
        self.selectedPlaceValid = selectedPlaceValid
        self.success = success
    }
}
