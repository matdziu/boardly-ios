//
//  MockAdminService.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 31/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockAdminService: AdminService {
    
    private var getAcceptedPlayersResult: Observable<[Player]> = Observable.empty()
    private var getPendingPlayersResult: Observable<[Player]> = Observable.empty()
    private var acceptPlayerResult: Observable<Bool> = Observable.empty()
    private var kickPlayerResult: Observable<Bool> = Observable.empty()
    private var sendRatingResult: Observable<Bool> = Observable.empty()
    private var fetchEventDetailsResult: Observable<BoardlyEvent> = Observable.empty()
    private var removePlayerResult: Observable<Bool> = Observable.empty()
    
    init(getAcceptedPlayers: Observable<[Player]> = Observable.empty(),
         getPendingPlayers: Observable<[Player]> = Observable.empty(),
         acceptPlayer: Observable<Bool> = Observable.empty(),
         kickPlayer: Observable<Bool> = Observable.empty(),
         sendRating: Observable<Bool> = Observable.empty(),
         fetchEventDetails: Observable<BoardlyEvent> = Observable.empty(),
         removePlayer: Observable<Bool> = Observable.empty()) {
        self.getAcceptedPlayersResult = getAcceptedPlayers
        self.getPendingPlayersResult = getPendingPlayers
        self.acceptPlayerResult = acceptPlayer
        self.kickPlayerResult = kickPlayer
        self.sendRatingResult = sendRating
        self.fetchEventDetailsResult = fetchEventDetails
        self.removePlayerResult = removePlayer
    }
    
    func getAcceptedPlayers(eventId: String) -> Observable<[Player]> {
        return getAcceptedPlayersResult
    }
    
    func getPendingPlayers(eventId: String) -> Observable<[Player]> {
        return getPendingPlayersResult
    }
    
    func acceptPlayer(eventId: String, playerId: String) -> Observable<Bool> {
        return acceptPlayerResult
    }
    
    func kickPlayer(eventId: String, playerId: String) -> Observable<Bool> {
        return kickPlayerResult
    }
    
    func sendRating(rateInput: RateInput) -> Observable<Bool> {
        return sendRatingResult
    }
    
    func fetchEventDetails(eventId: String) -> Observable<BoardlyEvent> {
        return fetchEventDetailsResult
    }
    
    func removePlayer(eventId: String, playerId: String) -> Observable<Bool> {
        return removePlayerResult
    }
}
