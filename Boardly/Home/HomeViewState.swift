//
//  HomeViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 02/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct HomeViewState: Equatable {
    var progress: Bool = false
    var locationProcessing: Bool = false
    var eventList: [Event] = []
    var joinRequestSent: Bool = false
    
    init(progress: Bool = false,
         locationProcessing: Bool = false,
         eventList: [Event] = [],
         joinRequestSent: Bool = false) {
        self.progress = progress
        self.locationProcessing = locationProcessing
        self.eventList = eventList
        self.joinRequestSent = joinRequestSent
    }
}
