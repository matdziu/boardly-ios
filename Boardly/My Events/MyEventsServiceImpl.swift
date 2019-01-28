//
//  MyEventsServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 27/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class MyEventsServiceImpl: BaseServiceImpl, MyEventsService {
    
    func getPendingEvents() -> Observable<[BoardlyEvent]> {
        return pendingEventIdsList().flatMap { return self.events(idsList: $0) }
    }
    
    func getAcceptedEvents() -> Observable<[BoardlyEvent]> {
        return acceptedEventIdsList().flatMap { return self.events(idsList: $0) }
    }
    
    func getCreatedEvents() -> Observable<[BoardlyEvent]> {
        return createdEventIdsList().flatMap { return self.events(idsList: $0) }
    }
    
    func getInterestingEvents() -> Observable<[BoardlyEvent]> {
        return interestingEventIdsList().flatMap { return self.events(idsList: $0) }
    }
}
