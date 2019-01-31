//
//  AdminPresenter.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 31/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class AdminPresenter {
    
    private let adminInteractor: AdminInteractor
    private var disposeBag = DisposeBag()
    private let stateSubject: BehaviorSubject<AdminViewState>
    
    init(adminInteractor: AdminInteractor,
         initialViewState: AdminViewState = AdminViewState()) {
        self.adminInteractor = adminInteractor
        self.stateSubject = BehaviorSubject(value: initialViewState)
    }
    
    func bind(adminView: AdminView, eventId: String) {
        let fetchEventTriggerObservable = adminView.fetchEventDetailsTriggerEmitter()
            .filter { $0 }
            .flatMap { _ in self.adminInteractor.fetchEvent(eventId: eventId).startWith(PartialAdminViewState.eventProgress) }
        
        let fetchPendingPlayersObservable = adminView.fetchEventDetailsTriggerEmitter()
            .filter { $0 }
            .flatMap { _ in self.adminInteractor.fetchPendingPlayers(eventId: eventId).startWith(PartialAdminViewState.pendingProgress) }
        
        let fetchAcceptedPlayersObservable = adminView.fetchEventDetailsTriggerEmitter()
            .filter { $0 }
            .flatMap { _ in self.adminInteractor.fetchAcceptedPlayers(eventId: eventId).startWith(PartialAdminViewState.acceptedProgress) }
        
        let acceptPlayerObservable = adminView.acceptPlayerEmitter()
            .flatMap { self.adminInteractor.acceptPlayer(eventId: eventId, playerId: $0) }
        
        let updatePendingListObservable = adminView.acceptPlayerEmitter()
            .map { playerId -> PartialAdminViewState in
                let currentState = (try? self.stateSubject.value()) ?? AdminViewState()
                let pendingList = currentState.pendingPlayersList.filter { playerId != $0.id }
                return PartialAdminViewState.pendingList(playersList: pendingList)
        }
        
        let kickPlayerObservable = adminView.kickPlayerEmitter()
            .flatMap { self.adminInteractor.kickPlayer(eventId: eventId, playerId: $0) }
        
        let updateAcceptedListObservable = adminView.kickPlayerEmitter()
            .map { playerId -> PartialAdminViewState in
                let currentState = (try? self.stateSubject.value()) ?? AdminViewState()
                let acceptedList = currentState.acceptedPlayersList.filter { playerId != $0.id }
                return PartialAdminViewState.acceptedList(playersList: acceptedList)
        }
        
        let sendRatingObservable = adminView.ratingEmitter()
            .flatMap { self.adminInteractor.sendRating(rateInput: $0) }
        
        let updateRateOrSelfObservable = adminView.ratingEmitter()
            .map { rateInput -> PartialAdminViewState in
                let currentState = (try? self.stateSubject.value()) ?? AdminViewState()
                let acceptedList = mapToRatedAllWhere({ $0.id == rateInput.playerId }, in: currentState.acceptedPlayersList)
                return PartialAdminViewState.acceptedList(playersList: acceptedList)
        }
        
        Observable
            .merge([
                fetchEventTriggerObservable,
                fetchPendingPlayersObservable,
                fetchAcceptedPlayersObservable,
                acceptPlayerObservable,
                updatePendingListObservable,
                kickPlayerObservable,
                updateAcceptedListObservable,
                sendRatingObservable,
                updateRateOrSelfObservable])
            .scan(try! stateSubject.value()) { (viewState: AdminViewState, partialState: PartialAdminViewState) -> AdminViewState in
                return self.reduce(previousState: viewState, partialState: partialState)
            }
            .observeOn(MainScheduler.instance)
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
        
        stateSubject
            .subscribe(onNext: {(viewState: AdminViewState) in
                adminView.render(adminViewState: viewState)
            })
            .disposed(by: disposeBag)
    }
    
    private func reduce(previousState: AdminViewState, partialState: PartialAdminViewState) -> AdminViewState {
        return partialState.reduce(previousState: previousState)
    }
    
    func unbind() {
        disposeBag = DisposeBag()
    }
}
