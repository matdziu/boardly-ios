//
//  NotifyPresenter.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 24/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class NotifyPresenter {
    
    private let notifyInteractor: NotifyInteractor
    private var disposeBag = DisposeBag()
    private let stateSubject: BehaviorSubject<NotifyViewState>
    
    init(notifyInteractor: NotifyInteractor,
         initialViewState: NotifyViewState = NotifyViewState()) {
        self.notifyInteractor = notifyInteractor
        self.stateSubject = BehaviorSubject(value: initialViewState)
    }
    
    func bind(notifyView: NotifyView) {
        let notifySettingsObservable = notifyView.notifySettingsEmitter().flatMap { notifySettings in
            return self.validateNotifySettings(notifySettings: notifySettings, actionWhenValid: { self.notifyInteractor.updateNotifySettings(notifySettings: $0) })
        }
        
        let notifySettingsFetchObservable = notifyView.notifySettingsFetchEmitter()
            .filter { return $0 }
            .flatMap { _ in return self.notifyInteractor.fetchNotifySettings().startWith(.progress) }
        
        let stopNotificationsObservable = notifyView.stopNotificationsButtonClickEmitter()
            .flatMap { _ in return self.notifyInteractor.deleteNotifications().startWith(.progress) }
        
        let placePickEventObservable = notifyView.placePickEventEmitter()
            .map { _ in return PartialNotifyViewState.placePicked }
        
        Observable
            .merge([notifySettingsObservable,
                    notifySettingsFetchObservable,
                    stopNotificationsObservable,
                    placePickEventObservable])
            .scan(try! stateSubject.value()) { (viewState: NotifyViewState, partialState: PartialNotifyViewState) -> NotifyViewState in return self.reduce(previousState: viewState, partialState: partialState)
            }
            .observeOn(MainScheduler.instance)
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
        
        stateSubject
            .subscribe (onNext: {(viewState: NotifyViewState) in
                notifyView.render(notifyViewState: viewState)
            })
            .disposed(by: disposeBag)
    }
    
    private func validateNotifySettings(notifySettings: NotifySettings, actionWhenValid: (NotifySettings) -> Observable<PartialNotifyViewState>) -> Observable<PartialNotifyViewState> {
        let selectedPlaceValid = !notifySettings.locationName.isEmpty
        if selectedPlaceValid {
            return actionWhenValid(notifySettings).startWith(.progress)
        } else {
            return Observable.just(PartialNotifyViewState.localValidation(selectedPlaceValid: selectedPlaceValid))
        }
    }
    
    private func reduce(previousState: NotifyViewState, partialState: PartialNotifyViewState) -> NotifyViewState {
        return partialState.reduce(previousState: previousState)
    }
    
    func unbind() {
        disposeBag = DisposeBag()
    }
}
