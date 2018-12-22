//
//  MockSignUpService.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
@testable import Boardly

class MockSignUpService: SignUpService {
    
    private let mode: SignUpServiceMode
    
    init(mode: SignUpServiceMode) {
        self.mode = mode
    }
    
    func signUp(email: String, password: String) -> Observable<Bool> {
        if (mode == .success) {
            return Observable.just(true)
        }
        else {
            return Observable.error(MockAuthError())
        }
    }
}

enum SignUpServiceMode {
    case success, error
}

