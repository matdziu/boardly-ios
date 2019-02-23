//
//  DiscoverInteractorTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import RxSwift
import Nimble

class DiscoverInteractorTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let testPlaces = [BoardlyPlace(id: "1"), BoardlyPlace(id: "2")]
        let mockDiscoverService = MockDiscoverService(fetchPlacesList: Observable.just(testPlaces))
        let discoverInteractor = DiscoverInteractorImpl(discoverService: mockDiscoverService)
        
        describe("DiscoverInteractor") {
            
            it("successful places list fetching") {
                let output = try! discoverInteractor.fetchPlacesList(userLocation: UserLocation(latitude: 0.0, longitude: 0.0), radius: 50.0)
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialDiscoverViewState.placesListFetched(placesList: testPlaces)]))
            }
        }
    }
}
