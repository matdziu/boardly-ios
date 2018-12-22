//
//  SignUpInteractorImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class SignUpInteractorImpl: SignUpInteractor {
    
    private let signUpService: SignUpService
    
    init(signUpService: SignUpService) {
        self.signUpService = signUpService
    }
    
    func signUp(email: String, password: String) -> Observable<PartialSignUpViewState> {
        return signUpService.signUp(email: email, password: password).map({ _ in return .signUpSuccess })
            .catchError({ [unowned self] (error: Error) -> Observable<PartialSignUpViewState> in
                return self.emitErrorState(error: error)
            })
        
    }
    
    private func emitErrorState(error: Error) -> Observable<PartialSignUpViewState> {
        let errorState = PartialSignUpViewState.errorState(error: error as NSError, dismiss: true)
        let initialErrorState = PartialSignUpViewState.errorState(error: error as NSError, dismiss: false)
        return Observable.just(errorState).startWith(initialErrorState)
    }
}

