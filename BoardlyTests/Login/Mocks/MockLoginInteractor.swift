//
//  MockLoginInteractor.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import RxSwift
import FirebaseAuth
import FBSDKLoginKit

class MockLoginInteractor: LoginInteractor {
    
    private let mode: LoginInteractorMode
    private let isLogged: Bool
    private let isProfileFilled: Bool
    
    init(mode: LoginInteractorMode, isLogged: Bool = false, isProfileFilled: Bool = false) {
        self.mode = mode
        self.isLogged = isLogged
        self.isProfileFilled = isProfileFilled
    }
    
    func login(email: String, password: String) -> Observable<PartialLoginViewState> {
        if mode == .success {
            return Observable.just(.loginSuccess(isProfileFilled: false))
        } else {
            return Observable.just(PartialLoginViewState.errorState(error: DefaultAuthError() as NSError, dismiss: false))
        }
    }
    
    func login(credential: AuthCredential) -> Observable<PartialLoginViewState> {
        return Observable.just(.loginSuccess(isProfileFilled: false))
    }
    
    func login(token: FBSDKAccessToken) -> Observable<PartialLoginViewState> {
        return Observable.just(.loginSuccess(isProfileFilled: false))
    }
    
    func isLoggedIn() -> Observable<PartialLoginViewState> {
        if isLogged {
            return Observable.just(PartialLoginViewState.loginSuccess(isProfileFilled: isProfileFilled))
        } else {
            return Observable.just(PartialLoginViewState.notLoggedIn)
        }
    }
}

enum LoginInteractorMode {
    case success, error
}
