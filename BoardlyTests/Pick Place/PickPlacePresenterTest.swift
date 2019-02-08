//
//  PickPlacePresenterTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 08/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import Nimble
import RxSwift

class PickPlacePresenterTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let testSearchResults = [PlaceSearchResult(name: "Krakow", latitude: 50.0, longitude: 49.0)]
        let testError = NSError(domain: "testDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Something went wrong"])
        
        describe("PickPlacePresenter") {
            
            it("single character query") {
                let mockPickPlaceInteractor = MockPickPlaceInteractor(fetchSearchResults: Observable.just(PartialPickPlaceViewState.resultsFetched(searchResults: testSearchResults)))
                let pickPlacePresenter = PickPlacePresenter(pickPlaceInteractor: mockPickPlaceInteractor)
                let pickPlaceViewRobot = PickPlaceViewRobot(pickPlacePresenter: pickPlacePresenter)
                pickPlaceViewRobot.emitQuery(query: "a")
                pickPlaceViewRobot.assert(expectedViewStates: [PickPlaceViewState()])
            }
            
            it("search success") {
                let mockPickPlaceInteractor = MockPickPlaceInteractor(fetchSearchResults: Observable.just(PartialPickPlaceViewState.resultsFetched(searchResults: testSearchResults)))
                let pickPlacePresenter = PickPlacePresenter(pickPlaceInteractor: mockPickPlaceInteractor)
                let pickPlaceViewRobot = PickPlaceViewRobot(pickPlacePresenter: pickPlacePresenter)
                pickPlaceViewRobot.emitQuery(query: "test test")
                pickPlaceViewRobot.assert(expectedViewStates: [
                    PickPlaceViewState(),
                    PickPlaceViewState(progress: true),
                    PickPlaceViewState(searchResults: testSearchResults)])
            }
            
            it("search error") {
                let mockPickPlaceInteractor = MockPickPlaceInteractor(fetchSearchResults: Observable.just(PartialPickPlaceViewState.errorState(error: testError)))
                let pickPlacePresenter = PickPlacePresenter(pickPlaceInteractor: mockPickPlaceInteractor)
                let pickPlaceViewRobot = PickPlaceViewRobot(pickPlacePresenter: pickPlacePresenter)
                pickPlaceViewRobot.emitQuery(query: "query")
                pickPlaceViewRobot.assert(expectedViewStates: [
                    PickPlaceViewState(),
                    PickPlaceViewState(progress: true),
                    PickPlaceViewState(error: testError)])
            }
        }
    }
}

