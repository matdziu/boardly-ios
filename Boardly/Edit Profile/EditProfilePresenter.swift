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
        
    }
    
    func unbind() {
        disposeBag = DisposeBag()
    }
    
    private func reduce(previousState: EditProfileViewState, partialState: PartialEditProfileViewState) -> EditProfileViewState {
        return partialState.reduce(previousState: previousState)
    }
}
