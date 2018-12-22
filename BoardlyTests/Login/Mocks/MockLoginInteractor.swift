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
    
    init(mode: LoginInteractorMode) {
        self.mode = mode
    }
    
    func login(email: String, password: String) -> Observable<PartialLoginViewState> {
        if mode == .success {
            return Observable.just(.loginSuccess)
        } else {
            return Observable.just(PartialLoginViewState.errorState(error: DefaultAuthError() as NSError, dismiss: false))
        }
    }
    
    func login(credential: AuthCredential) -> Observable<PartialLoginViewState> {
        return Observable.just(.loginSuccess)
    }
    
    func login(token: FBSDKAccessToken) -> Observable<PartialLoginViewState> {
        return Observable.just(.loginSuccess)
    }
}

enum LoginInteractorMode {
    case success, error
}
