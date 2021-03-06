//
//  LoginViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct LoginViewState: Equatable {
    var progress: Bool = false
    var emailValid: Bool = true
    var passwordValid: Bool = true
    var error: Bool = false
    var loginSuccess: Bool = false
    var errorMessage: String = ""
    var dismissError: Bool = false
    var notLoggedIn: Bool = false
    var isProfileFilled: Bool = false
    
    init(progress: Bool = false,
         emailValid: Bool = true,
         passwordValid: Bool = true,
         error: Bool = false,
         loginSuccess: Bool = false,
         errorMessage: String = "",
         dismissError: Bool = false,
         notLoggedIn: Bool = false,
         isProfileFilled: Bool = false) {
        self.progress = progress
        self.emailValid = emailValid
        self.passwordValid = passwordValid
        self.error = error
        self.loginSuccess = loginSuccess
        self.errorMessage = errorMessage
        self.dismissError = dismissError
        self.notLoggedIn = notLoggedIn
        self.isProfileFilled = isProfileFilled
    }
}

