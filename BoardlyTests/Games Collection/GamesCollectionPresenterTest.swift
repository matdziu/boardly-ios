//
//  GamesCollectionPresenterTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import RxSwift

class GamesCollectionPresenterTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let testGames = [
            CollectionGame(id: "1",
                           name: "Inis"),
            CollectionGame(id: "2",
                           name: "Monopoly London"),
            CollectionGame(id: "3",
                           name: "Monopoly Krakow"),
            CollectionGame(id: "4",
                           name: "Eurobusiness")]
        let mockGamesCollectionInteractor = MockGamesCollectionInteractor(fetchGames: Observable.just(PartialGamesCollectionViewState.collectionFetched(gamesList: testGames)))
        
        var gamesCollectionPresenter: GamesCollectionPresenter!
        var gamesCollectionViewRobot: GamesCollectionViewRobot!
        
        beforeEach {
            gamesCollectionPresenter = GamesCollectionPresenter(gamesCollectionInteractor: mockGamesCollectionInteractor)
            gamesCollectionViewRobot = GamesCollectionViewRobot(gamesCollectionPresenter: gamesCollectionPresenter)
        }
        
        describe("GamesCollectionPresenter") {
            
            it("initial games collection fetch") {
                gamesCollectionViewRobot.initGamesFetching()
                gamesCollectionViewRobot.assert(expectedViewStates: [
                    GamesCollectionViewState(),
                    GamesCollectionViewState(progress: true),
                    GamesCollectionViewState(progress: false, games: testGames)])
            }
            
            it("query logic") {
                let testGamesAfterFirstQuery = [
                    CollectionGame(id: "2",
                                   name: "Monopoly London"),
                    CollectionGame(id: "3",
                                   name: "Monopoly Krakow")]
                let testGamesAfterSecondQuery = [
                    CollectionGame(id: "1",
                                   name: "Inis"),
                    CollectionGame(id: "4",
                                   name: "Eurobusiness")]
                gamesCollectionViewRobot.initGamesFetching()
                gamesCollectionViewRobot.emitQuery(query: "MONOPoly  ")
                gamesCollectionViewRobot.emitQuery(query: "in")
                gamesCollectionViewRobot.emitQuery(query: "sfjsfiosd")
                gamesCollectionViewRobot.assert(expectedViewStates: [
                    GamesCollectionViewState(),
                    GamesCollectionViewState(progress: true),
                    GamesCollectionViewState(progress: false, games: testGames),
                    GamesCollectionViewState(progress: false, games: testGamesAfterFirstQuery),
                    GamesCollectionViewState(progress: false, games: testGamesAfterSecondQuery),
                    GamesCollectionViewState(progress: false, games: [])])
            }
        }
    }
}
