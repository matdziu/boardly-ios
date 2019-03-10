//
//  HomeInteractorTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 02/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import RxSwift
import Nimble

class HomeInteractorTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        var event1 = BoardlyEvent()
        event1.eventId = "1"
        event1.gameId = "test"
        event1.placeLatitude = 50.0
        event1.placeLongitude = 50.0
        var event2 = BoardlyEvent()
        event2.eventId = "2"
        event2.timestamp = 1000
        event2.gameId = "test"
        event2.placeLatitude = 50.0
        event2.placeLongitude = 50.0
        var event3 = BoardlyEvent()
        event3.eventId = "3"
        event3.gameId = "test"
        event3.placeLatitude = 50.0
        event3.placeLongitude = 50.0
        
        let testEventList = [event1, event2]
        let testCreatedEventsList = [event3]
        let testEventIdsList = ["1"]
        
        let mockHomeService = MockHomeService(
            fetchAllEvents: Observable.just(testEventList),
            fetchCreatedEvents: Observable.just(testCreatedEventsList),
            fetchUserEvents: Observable.just(testEventIdsList),
            sendJoinRequest: Observable.just(true))
        
        let homeInteractor = HomeInteractorImpl(homeService: mockHomeService)
        
        describe("HomeInteractor") {
            
            it("successful event fetching inside radius") {
                let output = try! homeInteractor.fetchEvents(userLocation: UserLocation(latitude: 48.0, longitude: 50.0), radius: 1000, gameId: "test")
                    .toBlocking()
                    .toArray()
                var createdEvent1 = event1
                createdEvent1.type = EventType.CREATED
                expect(output).to(equal([PartialHomeViewState.eventListState(eventList: [createdEvent1])]))
            }
            
            it("successful event fetching outside radius") {
                let output = try! homeInteractor.fetchEvents(userLocation: UserLocation(latitude: 48.0, longitude: 50.0), radius: 1, gameId: "test")
                    .toBlocking()
                    .toArray()
                expect(output).to(equal([PartialHomeViewState.eventListState(eventList: [])]))
            }
            
            it("successful join event request") {
                let output = try! homeInteractor.joinEvent(joinEventData: JoinEventData(eventId: "1", helloText: "hi"))
                    .toBlocking()
                    .toArray()
                expect(output).to(equal([PartialHomeViewState.joinRequestSent(render: true),
                                         PartialHomeViewState.joinRequestSent(render: false)]))
            }
            
            it("event fetching when user location is nil") {
                let output = try! homeInteractor.fetchEvents(userLocation: nil, radius: 10.0, gameId: "1")
                    .toBlocking()
                    .toArray()
                expect(output).to(equal([PartialHomeViewState.eventListState(eventList: [])]))
            }
        }
    }
}
