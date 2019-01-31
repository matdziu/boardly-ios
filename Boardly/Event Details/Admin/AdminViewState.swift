//
//  AdminViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 31/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct AdminViewState: Equatable {
    
    var acceptedProgress: Bool = false
    var pendingProgress: Bool = false
    var eventProgress: Bool = false
    var acceptedPlayersList: [Player] = []
    var pendingPlayersList: [Player] = []
    var event: BoardlyEvent = BoardlyEvent()
    
    init(acceptedProgress: Bool = false,
         pendingProgress: Bool = false,
         eventProgress: Bool = false,
         acceptedPlayersList: [Player] = [],
         pendingPlayersList: [Player] = [],
         event: BoardlyEvent = BoardlyEvent()) {
        self.acceptedProgress = acceptedProgress
        self.pendingProgress = pendingProgress
        self.eventProgress = eventProgress
        self.acceptedPlayersList = acceptedPlayersList
        self.pendingPlayersList = pendingPlayersList
        self.event = event
    }
}
