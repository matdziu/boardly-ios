//
//  MockLoginService.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
@testable import Boardly

class MockLoginService: LoginService {
    
    private let mode: LoginServiceMode
    
    init(mode: LoginServiceMode) {
        self.mode = mode
    }
    
    func login(email: String, password: String) -> Observable<Bool> {
        return Observable.just(mode == .success)
    }
}

enum LoginServiceMode {
    case success, error
}
