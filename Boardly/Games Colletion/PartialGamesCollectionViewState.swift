//
//  PartialGamesCollectionViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

enum PartialGamesCollectionViewState: Equatable {
    case progress
    case collectionFetched(gamesList: [CollectionGame])
    
    func reduce(previousState: GamesCollectionViewState) -> GamesCollectionViewState {
        var newState = previousState
        switch self {
        case .progress:
            newState.progress = true
            return newState
        case .collectionFetched(let gamesList):
            newState.progress = false
            newState.games = gamesList
            return newState
        }
    }
}
