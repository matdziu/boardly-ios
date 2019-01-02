//
//  PartialHomeViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 02/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

enum PartialHomeViewState: Equatable {
    case progress
    case eventListState(eventList: [BoardlyEvent])
    case joinRequestSent(render: Bool)
    case locationProcessingState
    
    func reduce(previousState: HomeViewState) -> HomeViewState {
        switch self {
        case .progress:
            return HomeViewState(progress: true)
        case .eventListState(let eventList):
            return HomeViewState(eventList: eventList)
        case .joinRequestSent(let render):
            var newState = previousState
            newState.joinRequestSent = render
            return newState
        case .locationProcessingState:
            return HomeViewState(locationProcessing: true)
        }
    }
}
