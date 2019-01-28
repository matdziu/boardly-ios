//
//  MyEventsInteractorTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 27/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import RxSwift
import Nimble

class MyEventsInteractorTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        describe("MyEventsInteractor") {
            
            it("successful pending, created, accepted and interesting events merging") {
                let acceptedEventsList = [BoardlyEvent(eventId: "1", eventName: "sampleAcceptedEvent")]
                let pendingEventsList = [BoardlyEvent(eventId: "2", eventName: "samplePendingEvent")]
                let createdEventsList = [BoardlyEvent(eventId: "3", eventName: "sampleCreatedEvent", timestamp: 1000)]
                let interestingEventsList = [BoardlyEvent(eventId: "2", eventName: "sampleInterestingEvent")]
                let myEventsService = MockMyEventsService(
                    getPendingEvents: Observable.just(pendingEventsList),
                    getAcceptedEvents: Observable.just(acceptedEventsList),
                    getInterestingEvents: Observable.just(interestingEventsList),
                    getCreatedEvents: Observable.just(createdEventsList))
                let myEventsInteractor = MyEventsInteractorImpl(myEventsService: myEventsService)
                let output = try! myEventsInteractor
                    .fetchEvents()
                    .toBlocking()
                    .toArray()
                let outputAcceptedEventsList = [BoardlyEvent(eventId: "1", eventName: "sampleAcceptedEvent", type: EventType.ACCEPTED)]
                let outputPendingEventsList = [BoardlyEvent(eventId: "2", eventName: "samplePendingEvent", type: EventType.PENDING)]
                expect(output).to(equal([PartialMyEventsViewState.eventsFetched(
                    acceptedEvents: outputAcceptedEventsList,
                    pendingEvents: outputPendingEventsList,
                    createdEvents: [],
                    interestingEvents: [])]))
            }
        }
    }
}
