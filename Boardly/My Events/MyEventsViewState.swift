//
//  MyEventsViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 27/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct MyEventsViewState: Equatable {
    var progress: Bool = false
    var acceptedEvents: [BoardlyEvent] = []
    var pendingEvents: [BoardlyEvent] = []
    var createdEvents: [BoardlyEvent] = []
    var interestingEvents: [BoardlyEvent] = []
    var joinRequestSent: Bool = false
    
    init(progress: Bool = false,
         acceptedEvents: [BoardlyEvent] = [],
         pendingEvents: [BoardlyEvent] = [],
         createdEvents: [BoardlyEvent] = [],
         interestingEvents: [BoardlyEvent] = [],
         joinRequestSent: Bool = false) {
        self.progress = progress
        self.acceptedEvents = acceptedEvents
        self.pendingEvents = pendingEvents
        self.createdEvents = createdEvents
        self.interestingEvents = interestingEvents
        self.joinRequestSent = joinRequestSent
    }
}
