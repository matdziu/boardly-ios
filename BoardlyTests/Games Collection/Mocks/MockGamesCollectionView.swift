//
//  MockGamesCollectionView.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockGamesCollectionView: GamesCollectionView {
    
    var renderedStates: [GamesCollectionViewState] = []
    let initialFetchTriggerSubject = PublishSubject<Bool>()
    let queryEmitterSubject = PublishSubject<String>()
    
    func render(gamesCollectionViewState: GamesCollectionViewState) {
        renderedStates.append(gamesCollectionViewState)
    }
    
    func queryEmitter() -> Observable<String> {
        return queryEmitterSubject
    }
    
    func initialFetchTriggerEmitter() -> Observable<Bool> {
        return initialFetchTriggerSubject
    }
}

