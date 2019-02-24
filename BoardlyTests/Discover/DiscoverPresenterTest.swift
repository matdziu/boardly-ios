//
//  DiscoverPresenterTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import RxSwift

class DiscoverPresenterTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let testPlaces = [BoardlyPlace(id: "1"), BoardlyPlace(id: "2")]
        let mockDiscoverInteractor = MockDiscoverInteractor(fetchPlacesList: Observable.just(PartialDiscoverViewState.placesListFetched(placesList: testPlaces)))
        
        var discoverPresenter: DiscoverPresenter!
        var discoverViewRobot: DiscoverViewRobot!
        
        beforeEach {
            discoverPresenter = DiscoverPresenter(discoverInteractor: mockDiscoverInteractor)
            discoverViewRobot = DiscoverViewRobot(discoverPresenter: discoverPresenter)
        }
        
        describe("DiscoverPresenter") {
            
            it("successful places list fetching") {
                discoverViewRobot.triggerPlacesFetch(placeFilteredFetchData: PlaceFilteredFetchData(userLocation: UserLocation(latitude: 0.0, longitude: 0.0)))
                discoverViewRobot.assert(expectedViewStates: [
                    DiscoverViewState(),
                    DiscoverViewState(progress: true),
                    DiscoverViewState(
                        progress: false,
                        placesList: testPlaces)])
            }
        }
    }
}
