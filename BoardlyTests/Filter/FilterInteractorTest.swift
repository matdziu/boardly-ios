//
//  FilterInteractorTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 30/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import Nimble
import RxSwift

class FilterInteractorTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        describe("FilterInteractor") {
            
            it("successfuly fetched game details") {
                let testGame = Game(id: "0", name: "testGame", image: "path/to/picture")
                let mockGameService = MockGameService(gameDetails: { _ in return Observable.just(DetailsResponse(game: testGame)) })
                let filterInteractor = FilterInteractorImpl(gameService: mockGameService)
                let output = try! filterInteractor.fetchGameDetails(gameId: "testGameId")
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([
                    PartialFilterViewState.gameDetailsFetched(game: testGame)]))
            }
            
            it("throws error during fetching") {
                let mockGameService = MockGameService(gameDetails: { _ in Observable.error(NSError()) })
                let filterInteractor = FilterInteractorImpl(gameService: mockGameService)
                let output = try! filterInteractor.fetchGameDetails(gameId: "testGameId")
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([
                    PartialFilterViewState.gameDetailsFetched(game: Game())]))
            }
        }
    }
}
