//
//  FilterInteractor.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 30/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class FilterInteractorImpl : FilterInteractor {
    
    private let gameService: GameService
    
    init(gameService: GameService) {
        self.gameService = gameService
    }
    
    func fetchGameDetails(gameId: String) -> Observable<PartialFilterViewState> {
        return gameService.gameDetails(id: gameId)
            .map({ detailsResponse -> PartialFilterViewState in
                return PartialFilterViewState.gameDetailsFetched(game: detailsResponse.game)
            })
    }
}
