//
//  AdminInteractor.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 31/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class AdminInteractorImpl: AdminInteractor {
    
    private let adminService: AdminService
    
    init(adminService: AdminService) {
        self.adminService = adminService
    }
    
    func fetchAcceptedPlayers(eventId: String) -> Observable<PartialAdminViewState> {
        return adminService.getAcceptedPlayers(eventId: eventId)
            .map { PartialAdminViewState.acceptedList(playersList: $0) }
    }
    
    func fetchPendingPlayers(eventId: String) -> Observable<PartialAdminViewState> {
        return adminService.getPendingPlayers(eventId: eventId)
            .map { PartialAdminViewState.pendingList(playersList: $0) }
    }
    
    func acceptPlayer(eventId: String, playerId: String) -> Observable<PartialAdminViewState> {
        return adminService.acceptPlayer(eventId: eventId, playerId: playerId)
            .map { _ in PartialAdminViewState.playerAccepted }
    }
    
    func kickPlayer(eventId: String, playerId: String) -> Observable<PartialAdminViewState> {
        return adminService.kickPlayer(eventId: eventId, playerId: playerId)
            .map { _ in PartialAdminViewState.playerKicked }
    }
    
    func sendRating(rateInput: RateInput) -> Observable<PartialAdminViewState> {
        return adminService.sendRating(rateInput: rateInput)
            .map { _ in PartialAdminViewState.ratingSent }
    }
    
    func fetchEvent(eventId: String) -> Observable<PartialAdminViewState> {
        return adminService.fetchEventDetails(eventId: eventId)
            .map { PartialAdminViewState.eventFetched(event: $0) }
    }
}
