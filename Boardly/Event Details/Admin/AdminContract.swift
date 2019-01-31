//
//  AdminContract.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 31/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

protocol AdminView: EventDetailsView {
    
    func render(adminViewState: AdminViewState)
    
    func fetchEventDetailsTriggerEmitter() -> Observable<Bool>
    
    func kickPlayerEmitter() -> Observable<String>
    
    func acceptPlayerEmitter() -> Observable<String>
}

protocol AdminInteractor {
    
    func fetchAcceptedPlayers(eventId: String) -> Observable<PartialAdminViewState>
    
    func fetchPendingPlayers(eventId: String) -> Observable<PartialAdminViewState>
    
    func acceptPlayer(eventId: String, playerId: String) -> Observable<PartialAdminViewState>
    
    func kickPlayer(eventId: String, playerId: String) -> Observable<PartialAdminViewState>
    
    func sendRating(rateInput: RateInput) -> Observable<PartialAdminViewState>
    
    func fetchEvent(eventId: String) -> Observable<PartialAdminViewState>
}

protocol AdminService: EventDetailsService {
    
    func getAcceptedPlayers(eventId: String) -> Observable<[Player]>
    
    func getPendingPlayers(eventId: String) -> Observable<[Player]>
    
    func acceptPlayer(eventId: String, playerId: String) -> Observable<Bool>
    
    func kickPlayer(eventId: String, playerId: String) -> Observable<Bool>
}
