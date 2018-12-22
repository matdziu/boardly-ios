//
//  MockLoginInteractor.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import RxSwift

class MockLoginInteractor: LoginInteractor {
    
    private let mode: LoginInteractorMode
    
    init(mode: LoginInteractorMode) {
        self.mode = mode
    }
    
    func login(email: String, password: String) -> Observable<PartialLoginViewState> {
        if mode == .success {
            return Observable.just(.loginSuccess)
        } else {
            return Observable.just(PartialLoginViewState.errorState(error: MockAuthError() as NSError, dismiss: false))
        }
    }
}

enum LoginInteractorMode {
    case success, error
}
