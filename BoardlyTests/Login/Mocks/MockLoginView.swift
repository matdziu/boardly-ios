//
//  MockLoginView.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
@testable import Boardly

class MockLoginView: LoginView {
    let inputDataSubject = PublishSubject<InputData>()
    var renderedStates: [LoginViewState] = []
    
    func inputEmitter() -> Observable<InputData> {
        return inputDataSubject
    }
    
    func render(loginViewState: LoginViewState) {
        renderedStates.append(loginViewState)
    }
}


