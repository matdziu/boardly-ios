//
//  EventPresenter.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 04/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class EventPresenter {
    
    private let eventInteractor: EventInteractor
    private var disposeBag = DisposeBag()
    private let stateSubject: BehaviorSubject<EventViewState>
    private let analytics = BoardlyAnalyticsImpl()
    
    init(eventInteractor: EventInteractor, initialViewState: EventViewState = EventViewState()) {
        self.eventInteractor = eventInteractor
        self.stateSubject = BehaviorSubject(value: initialViewState)
    }
    
    func bind(eventView: EventView) {
        let gamePickEventObservable = eventView.gamePickEventEmitter()
            .flatMap { gamePickEvent -> Observable<PartialEventViewState> in
                let gameDetailsObservable = self.eventInteractor.fetchGameDetails(gamePickEvent: gamePickEvent)
                if gamePickEvent.type == .first {
                    return gameDetailsObservable.startWith(.gamePickedState)
                } else {
                    return gameDetailsObservable
                }
        }
        
        let placePickEventObservable = eventView.placePickEventEmitter()
            .map { _ in return PartialEventViewState.placePickedState }
        
        let addEventObservable = eventView.addEventEmitter()
            .flatMap { eventInputData in
                return self.validateInputData(inputData: eventInputData, actionWhenValid: {
                    self.analytics.logEventAddedEvent(gameId: $0.gameId,
                                                 gameId2: $0.gameId2,
                                                 gameId3: $0.gameId3,
                                                 placeLatitude: $0.placeLatitude,
                                                 placeLongitude: $0.placeLongitude)
                    return self.eventInteractor.addEvent(inputData: $0)
                })
        }
        
        let editEventObservable = eventView.editEventEmitter()
            .flatMap { eventInputData in
                return self.validateInputData(inputData: eventInputData, actionWhenValid: { self.eventInteractor.editEvent(inputData: $0) })
        }
        
        let removeEventObservable = eventView.deleteEventEmitter()
            .flatMap { eventId in return self.eventInteractor.deleteEvent(eventId: eventId)}
        
        Observable
            .merge([gamePickEventObservable,
                    placePickEventObservable,
                    addEventObservable,
                    editEventObservable,
                    removeEventObservable])
            .scan(try! stateSubject.value()) { (viewState: EventViewState, partialState: PartialEventViewState) -> EventViewState in
                return self.reduce(previousState: viewState, partialState: partialState)
            }
            .observeOn(MainScheduler.instance)
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
        
        stateSubject
            .subscribe (onNext: {(viewState: EventViewState) in
                eventView.render(eventViewState: viewState)
            })
            .disposed(by: disposeBag)
    }
    
    private func validateInputData(inputData: EventInputData, actionWhenValid: (EventInputData) -> Observable<PartialEventViewState>) -> Observable<PartialEventViewState> {
        let eventNameValid = !inputData.eventName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let selectedGameValid = !inputData.gameId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let selectedPlaceValid = !inputData.placeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        if eventNameValid && selectedGameValid && selectedPlaceValid {
            return actionWhenValid(inputData).startWith(.progress)
        } else {
            return Observable.just(PartialEventViewState.localValidation(eventNameValid: eventNameValid, selectedGameValid: selectedGameValid, selectedPlaceValid: selectedPlaceValid))
        }
    }
    
    func unbind() {
        disposeBag = DisposeBag()
    }
    
    private func reduce(previousState: EventViewState, partialState: PartialEventViewState) -> EventViewState {
        return partialState.reduce(previousState: previousState)
    }
}
