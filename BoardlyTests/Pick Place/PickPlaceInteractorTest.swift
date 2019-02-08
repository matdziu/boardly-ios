//
//  PickPlaceInteractorTest.swift
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
import RxTest

class PickPlaceInteractorTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        describe("PickPlaceInteractor") {
            
            it("successful results fetching") {
                let testSearchResults = [PlaceSearchResult(name: "Krakow", latitude: 50.0, longitude: 49.0)]
                let mockPickPlaceService = MockPickPlaceService(search: Observable.just(testSearchResults))
                let pickPlaceInteractor = PickPlaceInteractorImpl(pickPlaceService: mockPickPlaceService)
                let output = try? pickPlaceInteractor.fetchSearchResults(query: "blabla")
                    .toBlocking()
                    .toArray()
                expect(output).to(equal([PartialPickPlaceViewState.resultsFetched(searchResults: testSearchResults)]))
            }
            
            it("results fetching with error") {
                let testError = NSError(domain: "test",
                                        code: 0,
                                        userInfo: [NSLocalizedDescriptionKey: "Something went wrong"])
                let mockPickPlaceService = MockPickPlaceService(search: Observable<[PlaceSearchResult]>.error(testError))
                let pickPlaceInteractor = PickPlaceInteractorImpl(pickPlaceService: mockPickPlaceService)
                let output = try? pickPlaceInteractor.fetchSearchResults(query: "blabla")
                    .toBlocking()
                    .toArray()
                expect(output).to(equal([PartialPickPlaceViewState.errorState(error: testError)]))
            }
        }
    }
}

