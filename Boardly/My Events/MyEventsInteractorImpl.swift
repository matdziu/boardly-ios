//
//  MyEventsInteractorImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 27/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class MyEventsInteractorImpl: MyEventsInteractor {
    
    private let myEventsService: MyEventsService
    
    init(myEventsService: MyEventsService) {
        self.myEventsService = myEventsService
    }
    
    func fetchEvents() -> Observable<PartialMyEventsViewState> {
        let pendingEventsObservable = myEventsService.getPendingEvents()
        let acceptedEventsObservable = myEventsService.getAcceptedEvents()
        let createdEventsObservable = myEventsService.getCreatedEvents()
        let interestingEventsObservable = myEventsService.getInterestingEvents()
        
        return Observable.zip(pendingEventsObservable, acceptedEventsObservable, createdEventsObservable, interestingEventsObservable) {
            pending, accepted, created, interesting in
            let other = pending + accepted + created
            return PartialMyEventsViewState.eventsFetched(
                acceptedEvents: self.appendType(events: accepted, type: EventType.ACCEPTED),
                pendingEvents: self.appendType(events: pending, type: EventType.PENDING),
                createdEvents: self.appendType(events: created, type: EventType.CREATED),
                interestingEvents: interesting.filter({ interestingEvent in return
                    !isOlderThanOneDay(timestamp: interestingEvent.timestamp) &&
                        !other.contains(where: { event in return event.eventId == interestingEvent.eventId })
                }))
        }
    }
    
    private func appendType(events: [BoardlyEvent], type: EventType) -> [BoardlyEvent] {
        return events.map({ event in
            var modifiedEvent = event
            modifiedEvent.type = type
            return modifiedEvent
        }).filter({ event in return !isOlderThanOneDay(timestamp: event.timestamp) })
    }
    
    func joinEvent(joinEventData: JoinEventData) -> Observable<PartialMyEventsViewState> {
        return myEventsService.sendJoinRequest(joinEventData: joinEventData)
            .map({ _ in return PartialMyEventsViewState.joinRequestSent(render: false) })
            .startWith(PartialMyEventsViewState.joinRequestSent(render: true))
    }
}
