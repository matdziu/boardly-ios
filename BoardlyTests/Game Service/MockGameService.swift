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
    let testSearchResult = SearchResult(id: 0, type: "RPG", name: "Monopoly", yearPublished: "1995")
    let testGame = Game(id: 0, name: "Monopoly", image: "url/to/image")
    
    init(mode: MockGameServiceMode) {
        self.mode = mode
    }
    
    func search(query: String) -> Observable<SearchResponse> {
        if mode == .success {
            return Observable.just(SearchResponse(searchResult: testSearchResult))
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
