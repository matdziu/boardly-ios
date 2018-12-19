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
        return signUpService.signUp(email: email, password: password).map({ (success: Bool) -> PartialSignUpViewState in
            if success {
                return .signUpSuccess
            } else {
                return .errorState
            }
        })
        
    }
}

