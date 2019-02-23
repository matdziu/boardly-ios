//
//  GamesCollectionInteractorTest.swift
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

class GamesCollectionInteractorTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let testGames = [CollectionGame(id: "1"),
                         CollectionGame(id: "2"),
                         CollectionGame(id: "3")]
        let mockGamesCollectionService = MockGamesCollectionService(fetchGames: Observable.just(testGames))
        let gamesCollectionInteractor = GamesCollectionInteractorImpl(gamesCollectionService: mockGamesCollectionService)
        
        describe("GamesCollectionInteractor") {
            
            it("successful games fetching") {
                let output = try! gamesCollectionInteractor.fetchGames(collectionId: "testCollectionId")
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialGamesCollectionViewState.collectionFetched(gamesList: testGames)]))
            }
        }
    }
}
