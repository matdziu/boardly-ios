//
//  SignUpViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct SignUpViewState: Equatable {
    var progress: Bool = false
    var emailValid: Bool = true
    var passwordValid: Bool = true
    var error: Bool = false
    var signUpSuccess: Bool = false
    var errorMessage: String = ""
    var dismissError: Bool = false
    
    init(progress: Bool = false,
         emailValid: Bool = true,
         passwordValid: Bool = true,
         error: Bool = false,
         signUpSuccess: Bool = false,
         errorMessage: String = "",
         dismissError: Bool = false) {
        self.progress = progress
        self.emailValid = emailValid
        self.passwordValid = passwordValid
        self.error = error
        self.signUpSuccess = signUpSuccess
        self.errorMessage = errorMessage
        self.dismissError = dismissError
    }
}
