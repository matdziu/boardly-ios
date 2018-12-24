//
//  PartialLoginViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import FirebaseAuth

enum PartialLoginViewState: Equatable {
    case progress
    case localValidation(emailValid: Bool, passwordValid: Bool)
    case loginSuccess(isProfileFilled: Bool)
    case notLoggedIn
    case errorState(error: NSError, dismiss: Bool)
    
    func reduce(previousState: LoginViewState) -> LoginViewState {
        switch self {
        case .progress:
            return LoginViewState(progress: true)
        case .localValidation(let emailValid, let passwordValid):
            return LoginViewState(emailValid: emailValid, passwordValid: passwordValid)
        case .loginSuccess(let isProfileFilled):
            return LoginViewState(
                progress: true,
                loginSuccess: true,
                notLoggedIn: false,
                isProfileFilled: isProfileFilled)
        case .notLoggedIn:
            return LoginViewState(
                progress: false,
                loginSuccess: false,
                notLoggedIn: false)
        case .errorState(let error, let dismiss):
            return LoginViewState(
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
            case .wrongPassword:
                return "This password is incorrect"
            case .userNotFound:
                return "This user does not exist"
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
