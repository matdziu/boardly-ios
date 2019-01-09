//
//  PickGamePresenterTest.swift
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

class PickGamePresenterTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let testSearchResults = [SearchResult(id: "0", type: "rpg", name: "Inis", yearPublished: "1995")]
        let testError = NSError(domain: "testDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Something went wrong"])
        
        describe("PickGamePresenter") {
            
            it("single character query") {
                let mockPickGameInteractor = MockPickGameInteractor(fetchSearchResults: Observable.just(PartialPickGameViewState.resultsFetched(searchResults: testSearchResults)))
                let pickGamePresenter = PickGamePresenter(pickGameInteractor: mockPickGameInteractor)
                let pickGameViewRobot = PickGameViewRobot(pickGamePresenter: pickGamePresenter)
                pickGameViewRobot.emitQuery(query: "a")
                pickGameViewRobot.assert(expectedViewStates: [PickGameViewState()])
            }
            
            it("search success") {
                let mockPickGameInteractor = MockPickGameInteractor(fetchSearchResults: Observable.just(PartialPickGameViewState.resultsFetched(searchResults: testSearchResults)))
                let pickGamePresenter = PickGamePresenter(pickGameInteractor: mockPickGameInteractor)
                let pickGameViewRobot = PickGameViewRobot(pickGamePresenter: pickGamePresenter)
                pickGameViewRobot.emitQuery(query: "test test")
                pickGameViewRobot.assert(expectedViewStates: [
                    PickGameViewState(),
                    PickGameViewState(progress: true),
                    PickGameViewState(searchResults: testSearchResults)])
            }
            
            it("search error") {
                let mockPickGameInteractor = MockPickGameInteractor(fetchSearchResults: Observable.just(PartialPickGameViewState.errorState(error: testError, unacceptedQuery: "query")))
                let pickGamePresenter = PickGamePresenter(pickGameInteractor: mockPickGameInteractor)
                let pickGameViewRobot = PickGameViewRobot(pickGamePresenter: pickGamePresenter)
                pickGameViewRobot.emitQuery(query: "query")
                pickGameViewRobot.assert(expectedViewStates: [
                    PickGameViewState(),
                    PickGameViewState(progress: true),
                    PickGameViewState(error: testError, unacceptedQuery: "query")])
            }
        }
    }
}
