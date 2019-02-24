//
//  DiscoverPresenter.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class DiscoverPresenter {
    
    private let discoverInteractor: DiscoverInteractor
    private var disposeBag = DisposeBag()
    private let stateSubject: BehaviorSubject<DiscoverViewState>
    
    init(discoverInteractor: DiscoverInteractor,
         initialViewState: DiscoverViewState = DiscoverViewState()) {
        self.discoverInteractor = discoverInteractor
        self.stateSubject = BehaviorSubject(value: initialViewState)
    }
    
    func bind(discoverView: DiscoverView) {
        let placesListObservable = discoverView.fetchPlacesListTrigger()
            .flatMap { self.discoverInteractor.fetchPlacesList(userLocation: $0.userLocation, radius: $0.radius).startWith(.progress) }
        
        Observable.merge([
            placesListObservable])
            .scan(try! stateSubject.value()) { (viewState: DiscoverViewState,
                partialState: PartialDiscoverViewState) -> DiscoverViewState in
                return self.reduce(previousState: viewState, partialState: partialState)
            }
            .observeOn(MainScheduler.instance)
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
        
        stateSubject
            .subscribe(onNext: { viewState in
                discoverView.render(discoverViewState: viewState)
            })
            .disposed(by: disposeBag)
    }
    
    func unbind() {
        disposeBag = DisposeBag()
    }
    
    private func reduce(previousState: DiscoverViewState, partialState: PartialDiscoverViewState) -> DiscoverViewState {
        return partialState.reduce(previousState: previousState)
    }
}
