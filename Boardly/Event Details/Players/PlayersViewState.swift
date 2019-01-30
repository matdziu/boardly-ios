//
//  PlayersViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct PlayersViewState: Equatable {
    
    var playersProgress: Bool = false
    var eventProgress: Bool = false
    var acceptedPlayersList: [Player] = []
    var kicked: Bool = false
    var left: Bool = false
    var event: BoardlyEvent = BoardlyEvent()
    
    init(playersProgress: Bool = false,
         eventProgress: Bool = false,
         acceptedPlayersList: [Player] = [],
         kicked: Bool = false,
         left: Bool = false,
         event: BoardlyEvent = BoardlyEvent()) {
        self.playersProgress = playersProgress
        self.eventProgress = eventProgress
        self.acceptedPlayersList = acceptedPlayersList
        self.kicked = kicked
        self.left = left
        self.event = event
    }
}
