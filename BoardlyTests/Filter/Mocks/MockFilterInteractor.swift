//
//  MockFilterInteractor.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 30/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockFilterInterator : FilterInteractor {
    
    let testGame = Game(id: 0, name: "Monopoly", image: "url/to/image")
    
    func fetchGameDetails(gameId: String) -> Observable<PartialFilterViewState> {
        return Observable.just(.gameDetailsFetched(game: testGame))
    }
}
