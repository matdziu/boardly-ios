//
//  MockLoginService.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth
@testable import Boardly

class MockLoginService: LoginService {
    
    private let mode: LoginServiceMode
    
    init(mode: LoginServiceMode) {
        self.mode = mode
    }
    
    func login(email: String, password: String) -> Observable<Bool> {
        if (mode == .success) {
            return Observable.just(true)
        }
        else {
            return Observable.error(DefaultAuthError())
        }
    }
    
    func login(credential: AuthCredential) -> Observable<Bool> {
        return Observable.just(true)
    }
}

enum LoginServiceMode {
    case success, error
}
