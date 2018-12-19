//
//  PartialLoginViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation

enum PartialLoginViewState: Equatable {
    case progress
    case localValidation(emailValid: Bool, passwordValid: Bool)
    case loginSuccess
    case errorState
    
    func reduce(previousState: LoginViewState) -> LoginViewState {
        switch self {
        case .progress:
            return LoginViewState(progress: true)
        case .localValidation(let emailValid, let passwordValid):
            return LoginViewState(emailValid: emailValid, passwordValid: passwordValid)
        case .loginSuccess:
            return LoginViewState(progress: true, loginSuccess: true)
        case .errorState:
            return LoginViewState(error: true)
        }
    }
}
