//
//  HomePresenterTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 02/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import RxSwift

class HomePresenterTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let testEventList = [BoardlyEvent(eventId: "111", eventName: "Come on", gameName: "Monopoly", gameId: "1", gameName2: "Inis", gameId2: "2", gameName3: "Mars", gameId3: "3", gameImageUrl: "path/to/pic/1", gameImageUrl2: "path/to/pic/2", gameImageUrl3: "path/to/pic/3", placeName: "some place", timestamp: 1234, description: "", placeLatitude: 1.0, placeLongitude: 1.0, adminId: "111111", type: EventType.DEFAULT)]
        let mockHomeInteractor = MockHomeInteractor(fetchEvents: Observable.just(PartialHomeViewState.eventListState(eventList: testEventList)), joinEvent: Observable.just(PartialHomeViewState.joinRequestSent(render: true)))
        
        var homePresenter: HomePresenter!
        var homeViewRobot: HomeViewRobot!
        
        beforeEach {
            homePresenter = HomePresenter(homeInteractor: mockHomeInteractor, initialViewState: HomeViewState())
            homeViewRobot = HomeViewRobot(homePresenter: homePresenter)
        }
        
        describe("HomePresenter") {
            
            it("successful event fetching with progress bar") {
                homeViewRobot.triggerFilteredFetch(filteredFetchData: FilteredFetchData(filter: Filter(), initialize: true))
                homeViewRobot.assert(expectedViewStates: [
                    HomeViewState(),
                    HomeViewState(progress: true),
                    HomeViewState(eventList: testEventList)])
            }
            
            it("successful event fetching without progress bar") {
                homeViewRobot.triggerFilteredFetch(filteredFetchData: FilteredFetchData(filter: Filter(), initialize: false))
                homeViewRobot.assert(expectedViewStates: [
                    HomeViewState(),
                    HomeViewState(eventList: testEventList)])
            }
            
            it("successful event joining") {
                homePresenter = HomePresenter(homeInteractor: mockHomeInteractor, initialViewState: HomeViewState(eventList: testEventList))
                homeViewRobot = HomeViewRobot(homePresenter: homePresenter)
                
                homeViewRobot.joinEvent(joinEventData: JoinEventData(eventId: "111", helloText: "hi"))
                homeViewRobot.assert(expectedViewStates: [
                    HomeViewState(eventList: testEventList),
                    HomeViewState(eventList: testEventList, joinRequestSent: true),
                    HomeViewState(joinRequestSent: false)])
            }
            
            it("show location being processed") {
                homeViewRobot.emitLocationProcessing(processing: true)
                homeViewRobot.emitLocationProcessing(processing: false)
                homeViewRobot.assert(expectedViewStates: [
                    HomeViewState(),
                    HomeViewState(locationProcessing: true)])
            }
        }
    }
}
