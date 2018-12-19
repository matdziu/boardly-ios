//
//  PartialSignUpViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation

enum PartialSignUpViewState: Equatable {
    case progress
    case localValidation(emailValid: Bool, passwordValid: Bool)
    case signUpSuccess
    case errorState
    
    func reduce(previousState: SignUpViewState) -> SignUpViewState {
        switch self {
        case .progress:
            return SignUpViewState(progress: true)
        case .localValidation(let emailValid, let passwordValid):
            return SignUpViewState(emailValid: emailValid, passwordValid: passwordValid)
        case .signUpSuccess:
            return SignUpViewState(progress: true, signUpSuccess: true)
        case .errorState:
            return SignUpViewState(error: true)
        }
    }
}

