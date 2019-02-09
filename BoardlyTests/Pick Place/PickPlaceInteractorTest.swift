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
            
            it("successful results fetching with delayed results scenario") {
                let firstQuery = "first query"
                let secondQuery = "second query"
                
                let testSearchResults = [PlaceSearchResult(name: "Krakow", latitude: 50.0, longitude: 49.0)]
                let delayedSearchResults = [PlaceSearchResult(name: "Warszawa", latitude: 20.0, longitude: 10.0)]
                
                let delayedSearchResponseSubject = PublishSubject<[PlaceSearchResult]>()
                let searchResultsObservable = Observable.just(testSearchResults)
                
                let mockPickPlaceService = MockPickPlaceService(search: { query -> Observable<[PlaceSearchResult]> in
                    switch query {
                    case firstQuery:
                        return delayedSearchResponseSubject
                    case secondQuery:
                        return searchResultsObservable
                    default:
                        return Observable<[PlaceSearchResult]>.empty()
                    }
                })
                
                var testDisposeBag: DisposeBag? = DisposeBag()
                
                let testScheduler = TestScheduler(initialClock: 0)
                let testObserver = testScheduler.createObserver(PartialPickPlaceViewState.self)
                let pickPlaceInteractor = PickPlaceInteractorImpl(pickPlaceService: mockPickPlaceService)
                pickPlaceInteractor.fetchSearchResults(query: firstQuery).subscribe(testObserver)
                    .disposed(by: testDisposeBag!)
                
                testScheduler.start()
                expect(testObserver.events.count).to(equal(0))
                
                pickPlaceInteractor.fetchSearchResults(query: secondQuery).subscribe(testObserver)
                    .disposed(by: testDisposeBag!)
                expect(testObserver.events).to(equal([Recorded.next(0, PartialPickPlaceViewState.resultsFetched(searchResults: testSearchResults)), Recorded.completed(0)]))
                
                delayedSearchResponseSubject.onNext(delayedSearchResults)
                expect(testObserver.events).to(equal([Recorded.next(0, PartialPickPlaceViewState.resultsFetched(searchResults: testSearchResults)), Recorded.completed(0)]))
                
                testScheduler.stop()
                testDisposeBag = nil
            }
            
            it("results fetching with error") {
                let testError = NSError(domain: "test",
                                        code: 0,
                                        userInfo: [NSLocalizedDescriptionKey: "Something went wrong"])
                let mockPickPlaceService = MockPickPlaceService(search: { _ in Observable<[PlaceSearchResult]>.error(testError) })
                let pickPlaceInteractor = PickPlaceInteractorImpl(pickPlaceService: mockPickPlaceService)
                let output = try? pickPlaceInteractor.fetchSearchResults(query: "blabla")
                    .toBlocking()
                    .toArray()
                expect(output).to(equal([PartialPickPlaceViewState.errorState(error: testError)]))
            }
        }
    }
}

