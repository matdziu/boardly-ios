//
//  MockAdminInteractor.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 31/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockAdminInteractor: AdminInteractor {
    
    private var fetchAcceptedPlayersResult: Observable<PartialAdminViewState> = Observable.empty()
    private var fetchPendingPlayersResult: Observable<PartialAdminViewState> = Observable.empty()
    private var acceptPlayerResult: Observable<PartialAdminViewState> = Observable.empty()
    private var kickPlayerResult: Observable<PartialAdminViewState> = Observable.empty()
    private var sendRatingResult: Observable<PartialAdminViewState> = Observable.empty()
    private var fetchEventResult: Observable<PartialAdminViewState> = Observable.empty()
    
    init(fetchAcceptedPlayers: Observable<PartialAdminViewState> = Observable.empty(),
         fetchPendingPlayers: Observable<PartialAdminViewState> = Observable.empty(),
         acceptPlayer: Observable<PartialAdminViewState> = Observable.empty(),
         kickPlayer: Observable<PartialAdminViewState> = Observable.empty(),
         sendRating: Observable<PartialAdminViewState> = Observable.empty(),
         fetchEvent: Observable<PartialAdminViewState> = Observable.empty()) {
        self.fetchAcceptedPlayersResult = fetchAcceptedPlayers
        self.fetchPendingPlayersResult = fetchPendingPlayers
        self.acceptPlayerResult = acceptPlayer
        self.kickPlayerResult = kickPlayer
        self.sendRatingResult = sendRating
        self.fetchEventResult = fetchEvent
    }
    
    func fetchAcceptedPlayers(eventId: String) -> Observable<PartialAdminViewState> {
        return fetchAcceptedPlayersResult
    }
    
    func fetchPendingPlayers(eventId: String) -> Observable<PartialAdminViewState> {
        return fetchPendingPlayersResult
    }
    
    func acceptPlayer(eventId: String, playerId: String) -> Observable<PartialAdminViewState> {
        return acceptPlayerResult
    }
    
    func kickPlayer(eventId: String, playerId: String) -> Observable<PartialAdminViewState> {
        return kickPlayerResult
    }
    
    func sendRating(rateInput: RateInput) -> Observable<PartialAdminViewState> {
        return sendRatingResult
    }
    
    func fetchEvent(eventId: String) -> Observable<PartialAdminViewState> {
        return fetchEventResult
    }
}

