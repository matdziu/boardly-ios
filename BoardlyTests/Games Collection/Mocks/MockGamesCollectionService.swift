//
//  MockGamesCollectionService.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockGamesCollectionService: GamesCollectionService {
    
    private var fetchGamesResult: Observable<[CollectionGame]> = Observable.empty()
    
    init(fetchGames: Observable<[CollectionGame]> = Observable.empty()) {
        self.fetchGamesResult = fetchGames
    }
    
    func fetchGames(collectionId: String) -> Observable<[CollectionGame]> {
        return fetchGamesResult
    }
}
