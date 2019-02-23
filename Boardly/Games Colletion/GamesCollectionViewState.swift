//
//  GamesCollectionViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct GamesCollectionViewState: Equatable {
    var progress: Bool = false
    var games: [CollectionGame] = []
    
    init(progress: Bool = false,
         games: [CollectionGame] = []) {
        self.progress = progress
        self.games = games
    }
}
