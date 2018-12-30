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

class FilterInteractorTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        describe("FilterInteractor") {
            
            it("successfuly fetched game details") {
                let mockGameService = MockGameService(mode: .success)
                let filterInteractor = FilterInteractorImpl(gameService: mockGameService)
                let output = try! filterInteractor.fetchGameDetails(gameId: "testGameId")
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([
                    PartialFilterViewState.gameDetailsFetched(game: mockGameService.testGame)]))
            }
            
            it("throws error during fetching") {
                let mockGameService = MockGameService(mode: .error)
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
