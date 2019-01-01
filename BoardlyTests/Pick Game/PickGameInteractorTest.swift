//
//  PickGameInteractorTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 31/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import Nimble
import RxSwift
import RxTest

class PickGameInteractorTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        describe("PickGameInteractor") {
            
            it("successful results fetching with delayed results scenario") {
                let firstQuery = "first query"
                let secondQuery = "second query"
                
                let searchResults = [SearchResult(id: 0, type: "boardgame", name: "Monopoly", yearPublished: "1995")]
                let delayedSearchResults = [SearchResult(id: 1, type: "rpg", name: "Inis", yearPublished: "2005")]
                
                let delayedSearchResponseSubject = PublishSubject<SearchResponse>()
                let searchResultsObservable = Observable.just(SearchResponse(games: searchResults))
                
                let mockGameService = MockGameService(search: { query -> Observable<SearchResponse> in
                    switch query {
                    case firstQuery:
                        return delayedSearchResponseSubject
                    case secondQuery:
                        return searchResultsObservable
                    default:
                        return Observable<SearchResponse>.empty()
                    }
                })
                
                var testDisposeBag: DisposeBag? = DisposeBag()
                
                let testScheduler = TestScheduler(initialClock: 0)
                let testObserver = testScheduler.createObserver(PartialPickGameViewState.self)
                let pickGameInteractor = PickGameInteractorImpl(gameService: mockGameService)
                pickGameInteractor.fetchSearchResults(query: firstQuery).subscribe(testObserver)
                .disposed(by: testDisposeBag!)
                
                testScheduler.start()
                expect(testObserver.events.count).to(equal(0))
                
                pickGameInteractor.fetchSearchResults(query: secondQuery).subscribe(testObserver)
                .disposed(by: testDisposeBag!)
                expect(testObserver.events).to(equal([Recorded.next(0, PartialPickGameViewState.resultsFetched(searchResults: searchResults)), Recorded.completed(0)]))
                
                delayedSearchResponseSubject.onNext(SearchResponse(games: delayedSearchResults))
                expect(testObserver.events).to(equal([Recorded.next(0, PartialPickGameViewState.resultsFetched(searchResults: searchResults)), Recorded.completed(0)]))
                
                testScheduler.stop()
                testDisposeBag = nil
            }
            
            it("results fetching with error") {
                let testError = NSError(domain: "test",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Something went wrong"])
                let mockGameService = MockGameService(search: { _ -> Observable<SearchResponse> in
                    return Observable.error(testError)
                })
                let pickGameInteractor = PickGameInteractorImpl(gameService: mockGameService)
                let output = try? pickGameInteractor.fetchSearchResults(query: "blabla")
                    .toBlocking()
                    .toArray()
                expect(output).to(equal([PartialPickGameViewState.errorState(error: testError, unacceptedQuery: "blabla")]))
            }
        }
    }
}
