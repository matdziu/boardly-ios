//
//  PickGameInteractorImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 31/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class PickGameInteractorImpl: PickGameInteractor {
    
    private var latestQuery = ""
    private let gameService: GameService
    
    init(gameService: GameService) {
        self.gameService = gameService
    }
    
    func fetchSearchResults(query: String) -> Observable<PartialPickGameViewState> {
        latestQuery = query
        return gameService.search(query: query)
            .map({ return PartialPickGameViewState.resultsFetched(searchResults: $0.games) })
            .catchError({ error -> Observable<PartialPickGameViewState> in
                return Observable.just(PartialPickGameViewState.errorState(error: error as NSError, unacceptedQuery: query))
            })
            .filter({ [unowned self] _ in query == self.latestQuery })
    }
}
