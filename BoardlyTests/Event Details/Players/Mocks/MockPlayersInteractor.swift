//
//  MockPlayersInteractor.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockPlayersInteractor: PlayersInteractor {
    
    private var fetchAcceptedPlayersResult: Observable<PartialPlayersViewState> = Observable.empty()
    private var sendRatingResult: Observable<PartialPlayersViewState> = Observable.empty()
    private var fetchEventResult: Observable<PartialPlayersViewState> = Observable.empty()
    private var leaveEventResult: Observable<PartialPlayersViewState> = Observable.empty()
    
    init(fetchAcceptedPlayers: Observable<PartialPlayersViewState> = Observable.empty(),
         sendRating: Observable<PartialPlayersViewState> = Observable.empty(),
         fetchEvent: Observable<PartialPlayersViewState> = Observable.empty(),
         leaveEvent: Observable<PartialPlayersViewState> = Observable.empty()) {
        self.fetchAcceptedPlayersResult = fetchAcceptedPlayers
        self.sendRatingResult = sendRating
        self.fetchEventResult = fetchEvent
        self.leaveEventResult = leaveEvent
    }
    
    func fetchAcceptedPlayers(eventId: String) -> Observable<PartialPlayersViewState> {
        return fetchAcceptedPlayersResult
    }
    
    func sendRating(rateInput: RateInput) -> Observable<PartialPlayersViewState> {
        return sendRatingResult
    }
    
    func fetchEvent(eventId: String) -> Observable<PartialPlayersViewState> {
        return fetchEventResult
    }
    
    func leaveEvent(eventId: String) -> Observable<PartialPlayersViewState> {
        return leaveEventResult
    }
}
