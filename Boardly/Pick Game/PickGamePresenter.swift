//
//  PickGamePresenter.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 31/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class PickGamePresenter {
    
    private let pickGameInteractor: PickGameInteractor
    private var disposeBag = DisposeBag()
    private let stateSubject: BehaviorSubject<PickGameViewState>
    
    init(pickGameInteractor: PickGameInteractor,
         initialViewState: PickGameViewState = PickGameViewState()) {
        self.pickGameInteractor = pickGameInteractor
        self.stateSubject = BehaviorSubject(value: initialViewState)
    }
    
    func bind(pickGameView: PickGameView) {
        let queryObservable = pickGameView.queryEmitter()
            .filter { return $0.count > 1 }
            .flatMap { [unowned self] (query) -> Observable<PartialPickGameViewState> in
                return self.pickGameInteractor.fetchSearchResults(query: query).startWith(.progress)
        }
        
        Observable
            .merge([queryObservable])
            .scan(try! stateSubject.value()) { (viewState: PickGameViewState, partialState: PartialPickGameViewState) -> PickGameViewState in
                return self.reduce(previousState: viewState, partialState: partialState)
            }
            .observeOn(MainScheduler.instance)
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
        
        stateSubject
            .subscribe(onNext: {(viewState: PickGameViewState) in
                pickGameView.render(pickGameViewState: viewState)
            })
            .disposed(by: disposeBag)
    }
    
    func unbind() {
        disposeBag = DisposeBag()
    }
    
    private func reduce(previousState: PickGameViewState,
                        partialState: PartialPickGameViewState) -> PickGameViewState {
        return partialState.reduce(previousState: previousState)
    }
}
