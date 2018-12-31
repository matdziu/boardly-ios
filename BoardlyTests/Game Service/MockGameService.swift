//
//  MockGameService.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 30/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockGameService: GameService {
    
    private var mode: MockGameServiceMode
    let testSearchResults = [SearchResult(id: 0, type: "rpg", name: "Monopoly", yearPublished: "1995"),
                             SearchResult(id: 1, type: "boardgame", name: "Inis", yearPublished: "2001")]
    let testGame = Game(id: 0, name: "Monopoly", image: "url/to/image")
    
    init(mode: MockGameServiceMode) {
        self.mode = mode
    }
    
    func search(query: String) -> Observable<SearchResponse> {
        if mode == .success {
            return Observable.just(SearchResponse(games: testSearchResults))
        } else {
            return Observable.error(NSError())
        }
    }
    
    func gameDetails(id: String) -> Observable<DetailsResponse> {
        if mode == .success {
            return Observable.just(DetailsResponse(game: testGame))
        } else {
            return Observable.error(NSError())
        }
    }
}

enum MockGameServiceMode {
    case error, success
}
