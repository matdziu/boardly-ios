//
//  MockSignUpInteractor.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import RxSwift

class MockSignUpInteractor: SignUpInteractor {
    
    private let mode: SignUpInteractorMode
    
    init(mode: SignUpInteractorMode) {
        self.mode = mode
    }
    
    func signUp(email: String, password: String) -> Observable<PartialSignUpViewState> {
        if mode == .success {
            return Observable.just(.signUpSuccess)
        } else {
            return Observable.just(PartialSignUpViewState.errorState(error: MockAuthError() as NSError, dismiss: false))
        }
    }
}

enum SignUpInteractorMode {
    case success, error
}
