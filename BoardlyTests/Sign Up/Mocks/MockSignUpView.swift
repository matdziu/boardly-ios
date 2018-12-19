//
//  MockSignUpView.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
@testable import Boardly

class MockSignUpView: SignUpView {
    let inputDataSubject = PublishSubject<InputData>()
    var renderedStates: [SignUpViewState] = []
    
    func inputEmitter() -> Observable<InputData> {
        return inputDataSubject
    }
    
    func render(signUpViewState: SignUpViewState) {
        renderedStates.append(signUpViewState)
    }
}
