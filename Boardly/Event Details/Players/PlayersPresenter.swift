//
//  PlayersPresenter.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class PlayersPresenter {
    
    private let playersInteractor: PlayersInteractor
    private var disposeBag = DisposeBag()
    private let stateSubject: BehaviorSubject<PlayersViewState>
    
    init(playersInteractor: PlayersInteractor,
         initialViewState: PlayersViewState = PlayersViewState()) {
        self.playersInteractor = playersInteractor
        self.stateSubject = BehaviorSubject(value: initialViewState)
    }
    
    func bind(playersView: PlayersView, eventId: String) {
        let fetchEventTriggerObservable = playersView.fetchEventDetailsTriggerEmitter()
            .filter { $0 }
            .flatMap { _ in self.playersInteractor.fetchEvent(eventId: eventId).startWith(PartialPlayersViewState.eventProgress) }
        
        let fetchEventPlayersObservable = playersView.fetchEventDetailsTriggerEmitter()
            .filter { $0 }
            .flatMap { _ in self.playersInteractor.fetchAcceptedPlayers(eventId: eventId).startWith(PartialPlayersViewState.playersProgress) }
        
        let sendRatingObservable = playersView.ratingEmitter().flatMap { self.playersInteractor.sendRating(rateInput: $0) }
        
        let updateRatedOrSelfObservable = playersView.ratingEmitter().map { rateInput -> PartialPlayersViewState in
            let currentState = (try? self.stateSubject.value()) ?? PlayersViewState()
            let acceptedList = mapToRatedAllWhere({ $0.id == rateInput.playerId }, in: currentState.acceptedPlayersList)
            return PartialPlayersViewState.acceptedList(playersList: acceptedList)
        }
        
        let leaveEventObservable = playersView.leaveEventEmitter().flatMap { _ in self.playersInteractor.leaveEvent(eventId: eventId) }
        
        Observable
            .merge([fetchEventTriggerObservable,
                    fetchEventPlayersObservable,
                    sendRatingObservable,
                    updateRatedOrSelfObservable,
                    leaveEventObservable])
            .scan(try! stateSubject.value()) { (viewState: PlayersViewState, partialState: PartialPlayersViewState) -> PlayersViewState in
                return self.reduce(previousState: viewState, partialState: partialState)
            }
            .observeOn(MainScheduler.instance)
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
        
        stateSubject
            .subscribe(onNext: {(viewState: PlayersViewState) in
                playersView.render(playersViewState: viewState)
            })
            .disposed(by: disposeBag)
    }
    
    private func reduce(previousState: PlayersViewState, partialState: PartialPlayersViewState) -> PlayersViewState {
        return partialState.reduce(previousState: previousState)
    }
    
    func unbind() {
        disposeBag = DisposeBag()
    }
}
