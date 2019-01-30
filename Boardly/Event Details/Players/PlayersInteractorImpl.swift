//
//  PlayersInteractor.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class PlayersInteractorImpl: PlayersInteractor {
    
    private let playersService: PlayersService
    private var leavingEvent = false
    
    init(playersService: PlayersService) {
        self.playersService = playersService
    }
    
    func fetchAcceptedPlayers(eventId: String) -> Observable<PartialPlayersViewState> {
        return playersService.getAcceptedPlayers(eventId: eventId)
            .map({ playersList in
                if !playersList.contains(where: { $0.id == self.playersService.userId }) && !self.leavingEvent {
                    return PartialPlayersViewState.kicked
                } else {
                    return PartialPlayersViewState.acceptedList(playersList: playersList)
                }
            })
    }
    
    func sendRating(rateInput: RateInput) -> Observable<PartialPlayersViewState> {
        return playersService.sendRating(rateInput: rateInput)
            .map { _ in PartialPlayersViewState.ratingSent }
    }
    
    func fetchEvent(eventId: String) -> Observable<PartialPlayersViewState> {
        return playersService.fetchEventDetails(eventId: eventId)
            .map { PartialPlayersViewState.eventFetched(event: $0) }
    }
    
    func leaveEvent(eventId: String) -> Observable<PartialPlayersViewState> {
        leavingEvent = true
        return playersService.leaveEvent(eventId: eventId)
            .map { _ in PartialPlayersViewState.leftEvent }
    }
}
