//
//  PartialAdminViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 31/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

enum PartialAdminViewState: Equatable {
    case acceptedProgress
    case pendingProgress
    case eventProgress
    case acceptedList(playersList: [Player])
    case pendingList(playersList: [Player])
    case playerKicked
    case playerAccepted
    case ratingSent
    case eventFetched(event: BoardlyEvent)
    
    func reduce(previousState: AdminViewState) -> AdminViewState {
        var newState = previousState
        switch self {
        case .acceptedProgress:
            newState.acceptedProgress = true
            return newState
        case .pendingProgress:
            newState.pendingProgress = true
            return newState
        case .eventProgress:
            newState.eventProgress = true
            return newState
        case .acceptedList(let playersList):
            newState.acceptedProgress = false
            newState.acceptedPlayersList = playersList
            return newState
        case .pendingList(let playersList):
            newState.pendingProgress = false
            newState.pendingPlayersList = playersList
            return newState
        case .playerKicked:
            return previousState
        case .playerAccepted:
            return previousState
        case .ratingSent:
            return previousState
        case .eventFetched(let event):
            newState.eventProgress = false
            newState.event = event
            return newState
        }
    }
}
