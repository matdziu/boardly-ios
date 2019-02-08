//
//  PickPlacePresenter.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 08/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class PickPlacePresenter {
    
    private let pickPlaceInteractor: PickPlaceInteractor
    private var disposeBag = DisposeBag()
    private let stateSubject: BehaviorSubject<PickPlaceViewState>
    
    init(pickPlaceInteractor: PickPlaceInteractor,
         initialViewState: PickPlaceViewState = PickPlaceViewState()) {
        self.pickPlaceInteractor = pickPlaceInteractor
        self.stateSubject = BehaviorSubject(value: initialViewState)
    }
    
    func bind(pickPlaceView: PickPlaceView) {
        let queryObservable = pickPlaceView.queryEmitter()
            .filter { return $0.count > 1 }
            .flatMap { [unowned self] (query) -> Observable<PartialPickPlaceViewState> in
                return self.pickPlaceInteractor.fetchSearchResults(query: query).startWith(.progress)
        }
        
        Observable
            .merge([queryObservable])
            .scan(try! stateSubject.value()) { (viewState: PickPlaceViewState, partialState: PartialPickPlaceViewState) -> PickPlaceViewState in
                return self.reduce(previousState: viewState, partialState: partialState)
            }
            .observeOn(MainScheduler.instance)
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
        
        stateSubject
            .subscribe(onNext: {(viewState: PickPlaceViewState) in
                pickPlaceView.render(pickPlaceViewState: viewState)
            })
            .disposed(by: disposeBag)
    }
    
    func unbind() {
        disposeBag = DisposeBag()
    }
    
    private func reduce(previousState: PickPlaceViewState,
                        partialState: PartialPickPlaceViewState) -> PickPlaceViewState {
        return partialState.reduce(previousState: previousState)
    }
}
