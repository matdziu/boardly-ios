//
//  GamesCollectionInteractorImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class GamesCollectionInteractorImpl: GamesCollectionInteractor {
    
    private let gamesCollectionService: GamesCollectionService
    
    init(gamesCollectionService: GamesCollectionService) {
        self.gamesCollectionService = gamesCollectionService
    }
    
    func fetchGames(collectionId: String) -> Observable<PartialGamesCollectionViewState> {
        return gamesCollectionService.fetchGames(collectionId: collectionId)
            .map { PartialGamesCollectionViewState.collectionFetched(gamesList: $0) }
    }
}
