//
//  PartialChatViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

enum PartialChatViewState: Equatable {
    case messagesListChanged(newMessagesList: [Message])
    case newMessagesListenerRemoved
    
    func reduce(previousState: ChatViewState) -> ChatViewState {
        switch self {
        case .messagesListChanged(let newMessagesList):
            var newState = previousState
            newState.progress = false
            newState.messagesList = newMessagesList
            return newState
        case .newMessagesListenerRemoved:
            return previousState
        }
    }
}
