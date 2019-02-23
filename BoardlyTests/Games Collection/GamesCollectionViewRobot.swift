//
//  GamesCollectionViewRobot.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Nimble

class GamesCollectionViewRobot {
    
    private let gamesCollectionView = MockGamesCollectionView()
    
    init(gamesCollectionPresenter: GamesCollectionPresenter) {
        gamesCollectionPresenter.bind(gamesCollectionView: gamesCollectionView, collectionId: "testCollectionId")
    }
    
    func assert(expectedViewStates: [GamesCollectionViewState]) {
        expect(self.gamesCollectionView.renderedStates).to(equal(expectedViewStates))
    }
    
    func initGamesFetching() {
        gamesCollectionView.initialFetchTriggerSubject.onNext(true)
    }
    
    func emitQuery(query: String) {
        gamesCollectionView.queryEmitterSubject.onNext(query)
    }
}
