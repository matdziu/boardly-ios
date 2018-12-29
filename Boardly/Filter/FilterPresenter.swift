//
//  FilterPresenter.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 29/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class FilterPresenter {
    
    private let filterInteractor: FilterInteractor
    private var disposeBag = DisposeBag()
    private let stateSubject: BehaviorSubject<FilterViewState>
    
    init(filterInteractor: FilterInteractor, initialViewState: FilterViewState = FilterViewState()) {
        self.filterInteractor = filterInteractor
        self.stateSubject = BehaviorSubject(value: initialViewState)
    }
    
    func bind(filterView: FilterView) {
        let gameDetailsObservable = filterView.gameIdEmitter()
            .flatMap { [unowned self] gameId in
                return self.filterInteractor.fetchGameDetails(gameId: gameId)
        }
        
        let locationProcessingObservable = filterView.locationProcessingEmitter()
            .map { processing -> PartialFilterViewState in
                return PartialFilterViewState.locationProcessingState(processing: processing)
        }
        
        Observable
            .merge([gameDetailsObservable, locationProcessingObservable])
            .scan(try! stateSubject.value()) { (viewState: FilterViewState, partialState: PartialFilterViewState) -> FilterViewState in
                return self.reduce(previousState: viewState, partialState: partialState)
            }
            .observeOn(MainScheduler.instance)
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
        
        stateSubject
            .subscribe(onNext: {(viewState: FilterViewState) in
                filterView.render(filterViewState: viewState)
            })
            .disposed(by: disposeBag)
    }
    
    private func reduce(previousState: FilterViewState, partialState: PartialFilterViewState) -> FilterViewState {
        return partialState.reduce(previousState: previousState)
    }
    
    func unbind() {
        disposeBag = DisposeBag()
    }
}
