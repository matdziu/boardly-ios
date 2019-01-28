//
//  MyEventsPresenterTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 27/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import RxSwift

class MyEventsPresenterTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let testAcceptedEvents = [BoardlyEvent(eventId: "1", eventName: "testEvent", gameName: "testGameId", type: EventType.ACCEPTED)]
        let testInterestingEvents = [BoardlyEvent(eventId: "2", eventName: "testInterestingEvent", gameName: "testGameId2", type: EventType.DEFAULT)]
        var myEventsViewRobot: MyEventsViewRobot!
        
        beforeEach {
            let mockMyEventsInteractor = MockMyEventsInteractor(
                fetchEvents: Observable.just(PartialMyEventsViewState.eventsFetched(
                    acceptedEvents: testAcceptedEvents,
                    pendingEvents: [],
                    createdEvents: [],
                    interestingEvents: testInterestingEvents)),
                joinEvent: Observable.just(PartialMyEventsViewState.joinRequestSent(render: false))
                    .startWith(PartialMyEventsViewState.joinRequestSent(render: true)))
            myEventsViewRobot = MyEventsViewRobot(myEventsPresenter: MyEventsPresenter(myEventsInteractor: mockMyEventsInteractor))
        }
        
        describe("MyEventsPresenter") {
            
            it("successful events fetching with progress bar") {
                myEventsViewRobot.triggerEventsFetching(initialize: true)
                myEventsViewRobot.assert(expectedViewStates: [
                    MyEventsViewState(),
                    MyEventsViewState(progress: true),
                    MyEventsViewState(acceptedEvents: testAcceptedEvents, interestingEvents: testInterestingEvents)])
            }
            
            it("successful events fetching without progress bar") {
                myEventsViewRobot.triggerEventsFetching(initialize: false)
                myEventsViewRobot.assert(expectedViewStates: [
                    MyEventsViewState(),
                    MyEventsViewState(acceptedEvents: testAcceptedEvents, interestingEvents: testInterestingEvents)])
            }
            
            it("successful event joining") {
                myEventsViewRobot.triggerEventsFetching(initialize: false)
                myEventsViewRobot.joinEvent(joinEventData: JoinEventData(eventId: "2", helloText: "test hello text"))
                let newPendingList = [BoardlyEvent(eventId: "2", eventName: "testInterestingEvent", gameName: "testGameId2", type: EventType.PENDING)]
                myEventsViewRobot.assert(expectedViewStates: [
                    MyEventsViewState(),
                    MyEventsViewState(acceptedEvents: testAcceptedEvents, interestingEvents: testInterestingEvents),
                    MyEventsViewState(acceptedEvents: testAcceptedEvents, interestingEvents: testInterestingEvents, joinRequestSent: true),
                    MyEventsViewState(acceptedEvents: testAcceptedEvents, interestingEvents: testInterestingEvents, joinRequestSent: false),
                    MyEventsViewState(acceptedEvents: testAcceptedEvents, pendingEvents: newPendingList)])
            }
        }
    }
}
