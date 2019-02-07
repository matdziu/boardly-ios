//
//  HomePresenter.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 02/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class HomePresenter {
    
    private let homeInteractor: HomeInteractor
    private var disposeBag = DisposeBag()
    private let stateSubject: BehaviorSubject<HomeViewState>
    private let analytics = BoardlyAnalyticsImpl()
    
    init(homeInteractor: HomeInteractor,
         initialViewState: HomeViewState = HomeViewState()) {
        self.homeInteractor = homeInteractor
        self.stateSubject = BehaviorSubject(value: initialViewState)
    }
    
    func bind(homeView: HomeView) {
        let filteredFetchObservable = homeView.filteredFetchTriggerEmitter()
            .flatMap { filteredFetchData -> Observable<PartialHomeViewState> in
                let filter = filteredFetchData.filter
                let eventsObservable = self.homeInteractor.fetchEvents(userLocation: filter.userLocation,
                                                                       radius: filter.radius, gameId: filter.gameId)
                if filteredFetchData.initialize {
                    return eventsObservable.startWith(PartialHomeViewState.progress)
                } else {
                    return eventsObservable
                }
        }
        
        let joinEventObservable = homeView.joinEventEmitter().flatMap { joinEventData -> Observable<PartialHomeViewState> in
            self.analytics.logJoinRequestSentEvent()
            return self.homeInteractor.joinEvent(joinEventData: joinEventData)
        }
        
        let updateEventListObservable = homeView.joinEventEmitter().map { joinEventData -> PartialHomeViewState in
            let currentState = (try? self.stateSubject.value()) ?? HomeViewState()
            let eventList = currentState.eventList.filter({ event -> Bool in
                return event.eventId != joinEventData.eventId
            })
            return PartialHomeViewState.eventListState(eventList: eventList)
        }
        
        let locationProcessingObservable = homeView.locationProcessingEmitter()
            .filter { return $0 }
            .map { _ -> PartialHomeViewState in
                return PartialHomeViewState.locationProcessingState
        }
        
        Observable.merge([
            filteredFetchObservable,
            joinEventObservable,
            updateEventListObservable,
            locationProcessingObservable])
            .scan(try! stateSubject.value()) { (viewState: HomeViewState,
                partialState: PartialHomeViewState) -> HomeViewState in
                return self.reduce(previousState: viewState, partialState: partialState)
            }
            .observeOn(MainScheduler.instance)
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
        
        stateSubject
            .subscribe(onNext: { viewState in
                homeView.render(homeViewState: viewState)
            })
            .disposed(by: disposeBag)
    }
    
    func unbind() {
        disposeBag = DisposeBag()
    }
    
    private func reduce(previousState: HomeViewState, partialState: PartialHomeViewState) -> HomeViewState {
        return partialState.reduce(previousState: previousState)
    }
}
