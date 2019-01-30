//
//  MockPlayersView.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockPlayersView: PlayersView {
    
    var renderedStates: [PlayersViewState] = []
    let fetchEventDetailsTriggerSubject = PublishSubject<Bool>()
    let leaveEventSubject = PublishSubject<Bool>()
    let ratingSubject = PublishSubject<RateInput>()
    
    func render(playersViewState: PlayersViewState) {
        renderedStates.append(playersViewState)
    }
    
    func fetchEventDetailsTriggerEmitter() -> Observable<Bool> {
        return fetchEventDetailsTriggerSubject
    }
    
    func leaveEventEmitter() -> Observable<Bool> {
        return leaveEventSubject
    }
    
    func ratingEmitter() -> Observable<RateInput> {
        return ratingSubject
    }
    
    func emitRating(rateInput: RateInput) {
        ratingSubject.onNext(rateInput)
    }
}
