//
//  PartialPlayersViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

enum PartialPlayersViewState: Equatable {
    case playersProgress
    case eventProgress
    case acceptedList(playersList: [Player])
    case ratingSent
    case kicked
    case leftEvent
    case eventFetched(event: BoardlyEvent)
    
    func reduce(previousState: PlayersViewState) -> PlayersViewState {
        var newState = previousState
        switch self {
        case .playersProgress:
            newState.playersProgress = true
            return newState
        case .eventProgress:
            newState.eventProgress = true
            return newState
        case .acceptedList(let playersList):
            newState.playersProgress = false
            newState.acceptedPlayersList = playersList
            return newState
        case .ratingSent:
            return newState
        case .kicked:
            return PlayersViewState(kicked: true)
        case .leftEvent:
            return PlayersViewState(left: true)
        case .eventFetched(let event):
            newState.eventProgress = false
            newState.event = event
            return newState
        }
    }
}
