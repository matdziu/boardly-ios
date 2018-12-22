//
//  PartialSignUpViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import FirebaseAuth

enum PartialSignUpViewState: Equatable {
    case progress
    case localValidation(emailValid: Bool, passwordValid: Bool)
    case signUpSuccess
    case errorState(error: NSError, dismiss: Bool)
    
    func reduce(previousState: SignUpViewState) -> SignUpViewState {
        switch self {
        case .progress:
            return SignUpViewState(progress: true)
        case .localValidation(let emailValid, let passwordValid):
            return SignUpViewState(emailValid: emailValid, passwordValid: passwordValid)
        case .signUpSuccess:
            return SignUpViewState(progress: true, signUpSuccess: true)
        case .errorState(let error, let dismiss):
            return SignUpViewState(
                error: true,
                errorMessage: getErrorMessage(error: error),
                dismissError: dismiss)
        }
    }
    
    private func getErrorMessage(error: NSError) -> String {
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            switch errorCode {
            case .invalidEmail:
                return "This email is incorrect"
            case .emailAlreadyInUse:
                return "This email is already used"
            case .networkError:
                return "You are not connected to the internet"
            default:
                return "Something went wrong :("
            }
        }
        else {
            return "Something went wrong :("
        }
    }
}

