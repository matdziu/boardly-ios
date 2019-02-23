//
//  MockGamesCollectionInteractor.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockGamesCollectionInteractor: GamesCollectionInteractor {
    
    private var fetchGamesResult: Observable<PartialGamesCollectionViewState> = Observable.empty()
    
    init(fetchGames: Observable<PartialGamesCollectionViewState> = Observable.empty()) {
        self.fetchGamesResult = fetchGames
    }
    
    func fetchGames(collectionId: String) -> Observable<PartialGamesCollectionViewState> {
        return fetchGamesResult
    }
}
