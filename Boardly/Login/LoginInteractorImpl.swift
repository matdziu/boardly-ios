//
//  LoginInteractorImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth
import FBSDKLoginKit

class LoginInteractorImpl: LoginInteractor {
    
    private let loginService: LoginService
    
    init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    func login(email: String, password: String) -> Observable<PartialLoginViewState> {
        return loginService.login(email: email, password: password).map({ return PartialLoginViewState.loginSuccess(isProfileFilled: $0) })
            .catchError({ [unowned self] (error: Error) -> Observable<PartialLoginViewState> in
                return self.emitErrorState(error: error)
            })
    }
    
    func login(credential: AuthCredential) -> Observable<PartialLoginViewState> {
        return loginUsingCredential(credential: credential)
    }
    
    func login(token: FBSDKAccessToken) -> Observable<PartialLoginViewState> {
        let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
        return loginUsingCredential(credential: credential)
    }
    
    func isLoggedIn() -> Observable<PartialLoginViewState> {
        return loginService.isLoggedIn().map({ (loginData) -> PartialLoginViewState in
            if loginData.isLoggedIn {
                return PartialLoginViewState.loginSuccess(isProfileFilled: loginData.isProfileFilled)
            } else {
                return PartialLoginViewState.notLoggedIn
            }
        })
    }
    
    private func loginUsingCredential(credential: AuthCredential) -> Observable<PartialLoginViewState> {
        return loginService.login(credential: credential).map({ return PartialLoginViewState.loginSuccess(isProfileFilled: $0) })
            .catchError({ [unowned self] (error: Error) -> Observable<PartialLoginViewState> in
                return self.emitErrorState(error: error)
            })
    }
    
    private func emitErrorState(error: Error) -> Observable<PartialLoginViewState> {
        let errorState = PartialLoginViewState.errorState(error: error as NSError, dismiss: true)
        let initialErrorState = PartialLoginViewState.errorState(error: error as NSError, dismiss: false)
        return Observable.just(errorState).startWith(initialErrorState)
    }
}
