//
//  LoginViewRobot.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
import Nimble
@testable import Boardly

class LoginViewRobot {
    
    private let mockLoginView = MockLoginView()
    init(loginPresenter: LoginPresenter) {
        loginPresenter.bind(loginView: mockLoginView)
    }
    
    func emitInputData(inputData: InputData) {
        mockLoginView.inputDataSubject.onNext(inputData)
    }
    
    func assert(expectedViewStates: [LoginViewState]) {
        expect(self.mockLoginView.renderedStates).to(equal(expectedViewStates))
    }
}
