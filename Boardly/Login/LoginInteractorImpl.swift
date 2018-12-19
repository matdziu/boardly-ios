//
//  LoginInteractorImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class LoginInteractorImpl: LoginInteractor {
    
    private let loginService: LoginService
    
    init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    func login(email: String, password: String) -> Observable<PartialLoginViewState> {
        return loginService.login(email: email, password: password).map({ (success: Bool) -> PartialLoginViewState in
            if success {
                return .loginSuccess
            } else {
                return .errorState
            }
        })
    }
}
