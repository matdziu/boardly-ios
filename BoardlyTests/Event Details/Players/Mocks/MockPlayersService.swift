//
//  MockPlayersService.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockPlayersService: PlayersService {
    
    private var userIdResult: String = ""
    private var getAcceptedPlayersResult: Observable<[Player]> = Observable.empty()
    private var leaveEventResult: Observable<Bool> = Observable.empty()
    private var sendRatingResult: Observable<Bool> = Observable.empty()
    private var fetchEventDetailsResult: Observable<BoardlyEvent> = Observable.empty()
    private var removePlayerResult: Observable<Bool> = Observable.empty()
    
    init(userId: String = "",
         getAcceptedPlayers: Observable<[Player]> = Observable.empty(),
         leaveEvent: Observable<Bool> = Observable.empty(),
         sendRating: Observable<Bool> = Observable.empty(),
         fetchEventDetails: Observable<BoardlyEvent> = Observable.empty(),
         removePlayer: Observable<Bool> = Observable.empty()) {
        self.userIdResult = userId
        self.getAcceptedPlayersResult = getAcceptedPlayers
        self.leaveEventResult = leaveEvent
        self.sendRatingResult = sendRating
        self.fetchEventDetailsResult = fetchEventDetails
        self.removePlayerResult = removePlayer
    }
    
    var userId: String {
        get {
            return userIdResult
        }
    }
    
    func getAcceptedPlayers(eventId: String) -> Observable<[Player]> {
        return getAcceptedPlayersResult
    }
    
    func leaveEvent(eventId: String) -> Observable<Bool> {
        return leaveEventResult
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
