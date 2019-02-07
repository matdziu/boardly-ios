//
//  MyEventsPresenter.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 27/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class MyEventsPresenter {
    
    private let myEventsInteractor: MyEventsInteractor
    private var disposeBag = DisposeBag()
    private let stateSubject:BehaviorSubject<MyEventsViewState>
    private let analytics = BoardlyAnalyticsImpl()
    
    init(myEventsInteractor: MyEventsInteractor,
         initialViewState: MyEventsViewState = MyEventsViewState()) {
        self.myEventsInteractor = myEventsInteractor
        self.stateSubject = BehaviorSubject(value: initialViewState)
    }
    
    func bind(myEventsView: MyEventsView) {
        let eventsFetchObservable = myEventsView.fetchEventsTriggerEmitter().flatMap { initialize -> Observable<PartialMyEventsViewState> in
            let myEventsObservable = self.myEventsInteractor.fetchEvents()
            if initialize {
                return myEventsObservable.startWith(PartialMyEventsViewState.progress)
            } else {
                return myEventsObservable
            }
        }
        
        let joinEventObservable = myEventsView.joinEventEmitter().flatMap { joinEventData -> Observable<PartialMyEventsViewState> in
            self.analytics.logJoinRequestSentEvent()
            return self.myEventsInteractor.joinEvent(joinEventData: joinEventData)
        }
        
        let updateEventListObservable = myEventsView.joinEventEmitter().map { joinEventData -> PartialMyEventsViewState in
            let currentState = (try? self.stateSubject.value()) ?? MyEventsViewState()
            var eventToBeJoined = currentState.interestingEvents.first(where: { event in event.eventId == joinEventData.eventId })
            let acceptedEvents = currentState.acceptedEvents
            let createdEvents = currentState.createdEvents
            if eventToBeJoined != nil {
                eventToBeJoined?.type = EventType.PENDING
                let pendingEvents = currentState.pendingEvents + [eventToBeJoined!]
                let interetingEvents = currentState.interestingEvents.filter({ event in
                    event.eventId != eventToBeJoined!.eventId
                })
                return PartialMyEventsViewState.eventsFetched(
                    acceptedEvents: acceptedEvents,
                    pendingEvents: pendingEvents,
                    createdEvents: createdEvents,
                    interestingEvents: interetingEvents)
            } else {
                return PartialMyEventsViewState.eventsFetched(
                    acceptedEvents: acceptedEvents,
                    pendingEvents: currentState.pendingEvents,
                    createdEvents: createdEvents,
                    interestingEvents: currentState.interestingEvents)
            }
        }
        
        Observable.merge([
            eventsFetchObservable,
            joinEventObservable,
            updateEventListObservable])
            .scan(try! stateSubject.value()) { (viewState: MyEventsViewState,
                partialState: PartialMyEventsViewState) -> MyEventsViewState in
                return self.reduce(previousState: viewState, partialState: partialState)
            }
            .observeOn(MainScheduler.instance)
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
        
        stateSubject
            .subscribe(onNext: { viewState in
                myEventsView.render(myEventsViewState: viewState)
            })
            .disposed(by: disposeBag)
    }
    
    func unbind() {
        disposeBag = DisposeBag()
    }
    
    private func reduce(previousState: MyEventsViewState, partialState: PartialMyEventsViewState) -> MyEventsViewState {
        return partialState.reduce(previousState: previousState)
    }
}
