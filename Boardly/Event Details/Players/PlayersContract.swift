//
//  PlayersContract.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

protocol PlayersView: EventDetailsView {
    
    func render(playersViewState: PlayersViewState)
    
    func fetchEventDetailsTriggerEmitter() -> Observable<Bool>
    
    func leaveEventEmitter() -> Observable<Bool>
}

protocol PlayersInteractor {
    
    func fetchAcceptedPlayers(eventId: String) -> Observable<PartialPlayersViewState>
    
    func sendRating(rateInput: RateInput) -> Observable<PartialPlayersViewState>
    
    func fetchEvent(eventId: String) -> Observable<PartialPlayersViewState>
    
    func leaveEvent(eventId: String) -> Observable<PartialPlayersViewState>
}

protocol PlayersService: EventDetailsService {
    
    var userId: String { get }
    
    func getAcceptedPlayers(eventId: String) -> Observable<[Player]>
    
    func leaveEvent(eventId: String) -> Observable<Bool>
}
