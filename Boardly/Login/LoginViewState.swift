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
    
    init(progress: Bool = false,
         emailValid: Bool = true,
         passwordValid: Bool = true,
         error: Bool = false,
         loginSuccess: Bool = false) {
        self.progress = progress
        self.emailValid = emailValid
        self.passwordValid = passwordValid
        self.error = error
        self.loginSuccess = loginSuccess
    }
}

