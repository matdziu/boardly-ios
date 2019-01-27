//
//  PartialMyEventsViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 27/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

enum PartialMyEventsViewState: Equatable {
    case progress
    case eventsFetched(
        acceptedEvents: [BoardlyEvent],
        pendingEvents: [BoardlyEvent],
        createdEvents: [BoardlyEvent],
        interestingEvents: [BoardlyEvent])
    case joinRequestSent(render: Bool)
    
    func reduce(previousState: MyEventsViewState) -> MyEventsViewState {
        switch self {
        case .progress:
            var newState = previousState
            newState.progress = true
            return newState
        case .eventsFetched(
            let acceptedEvents,
            let pendingEvents,
            let createdEvents,
            let interestingEvents):
            return MyEventsViewState(acceptedEvents: acceptedEvents,
                                     pendingEvents: pendingEvents,
                                     createdEvents: createdEvents,
                                     interestingEvents: interestingEvents)
        case .joinRequestSent(let render):
            var newState = previousState
            newState.joinRequestSent = render
            return newState
        }
    }
}
