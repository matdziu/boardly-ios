//
//  EditProfilePresenter.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 25/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class EditProfilePresenter {
    
    private let editProfileInteractor: EditProfileInteractor
    private var disposeBag = DisposeBag()
    private let stateSubject: BehaviorSubject<EditProfileViewState>
    
    init(editProfileInteractor: EditProfileInteractor, initialViewState: EditProfileViewState = EditProfileViewState()) {
        self.editProfileInteractor = editProfileInteractor
        self.stateSubject = BehaviorSubject(value: initialViewState)
    }
    
    func bind(editProfileView: EditProfileView) {
        let fetchDataObservable = editProfileView.fetchProfileDataTriggerEmitter()
            .filter({ return $0 })
            .flatMap { [unowned self] _ in return self.editProfileInteractor.fetchProfileData().startWith(.progress) }
        
        let inputDataObservable = editProfileView.inputDataEmitter()
            .flatMap { [unowned self] (inputData) -> Observable<PartialEditProfileViewState> in
                if !inputData.name.isEmpty {
                    return self.editProfileInteractor.saveProfileChanges(inputData: inputData).startWith(.progress)
                } else {
                    return Observable.just(PartialEditProfileViewState.nameFieldEmpty)
                }
        }
        
        Observable
            .merge([inputDataObservable, fetchDataObservable])
            .scan(try! stateSubject.value()) { (viewState: EditProfileViewState, partialState: PartialEditProfileViewState) -> EditProfileViewState in
                return self.reduce(previousState: viewState, partialState: partialState)
            }
            .observeOn(MainScheduler.instance)
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
        
        stateSubject
            .subscribe (onNext: {(viewState: EditProfileViewState) in
                editProfileView.render(editProfileViewState: viewState)
            })
            .disposed(by: disposeBag)
    }
    
    func unbind() {
        disposeBag = DisposeBag()
    }
    
    private func reduce(previousState: EditProfileViewState, partialState: PartialEditProfileViewState) -> EditProfileViewState {
        return partialState.reduce(previousState: previousState)
    }
}
