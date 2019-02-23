//
//  GamesCollectionContract.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

protocol GamesCollectionView {
    
    func render(gamesCollectionViewState: GamesCollectionViewState)
    
    func queryEmitter() -> Observable<String>
    
    func initialFetchTriggerEmitter() -> Observable<Bool>
}

protocol GamesCollectionService {
    
    func fetchGames(collectionId: String) -> Observable<[CollectionGame]>
}

protocol GamesCollectionInteractor {
    
    func fetchGames(collectionId: String) -> Observable<PartialGamesCollectionViewState>
}
