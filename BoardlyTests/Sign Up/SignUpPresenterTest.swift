//
//  SignUpPresenterTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Quick
@testable import Boardly

class SignUpPresenterTest: QuickSpec {
    
    override func spec() {
        super.spec()
        describe("SignUpPresenter") {
            context("valid data") {
                it("sign up success") {
                    let presenter = SignUpPresenter(signUpInteractor: MockSignUpInteractor(mode: .success))
                    let signUpViewRobot = SignUpViewRobot(signUpPresenter: presenter)
                    signUpViewRobot.emitInputData(inputData: InputData(email: "matdziu@gmail.com", password: "qwerty123"))
                    signUpViewRobot.assert(expectedViewStates: [
                        SignUpViewState(),
                        SignUpViewState(progress: true),
                        SignUpViewState(progress: true, signUpSuccess: true)])
                }
                
                it("sign up error") {
                    let presenter = SignUpPresenter(signUpInteractor: MockSignUpInteractor(mode: .error))
                    let signUpViewRobot = SignUpViewRobot(signUpPresenter: presenter)
                    signUpViewRobot.emitInputData(inputData: InputData(email: "matdziu@gmail.com", password: "qwerty123"))
                    signUpViewRobot.assert(expectedViewStates: [
                        SignUpViewState(),
                        SignUpViewState(progress: true),
                        SignUpViewState(error: true)])
                }
            }
            
            context("invalid data") {
                it("email and password are shown as invalid") {
                    let presenter = SignUpPresenter(signUpInteractor: MockSignUpInteractor(mode: .success))
                    let signUpViewRobot = SignUpViewRobot(signUpPresenter: presenter)
                    signUpViewRobot.emitInputData(inputData: InputData(email: "", password: ""))
                    signUpViewRobot.emitInputData(inputData: InputData(email: "matdziu@gmail.com", password: "aaaaa"))
                    signUpViewRobot.assert(expectedViewStates: [
                        SignUpViewState(),
                        SignUpViewState(emailValid: false, passwordValid: false),
                        SignUpViewState(emailValid: true, passwordValid: false)])
                }
            }
        }
    }
}

