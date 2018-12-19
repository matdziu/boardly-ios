//
//  LoginPresenterTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Quick
import RxSwift
@testable import Boardly

class LoginPresenterTest: QuickSpec {
    
    override func spec() {
        super.spec()
        describe("LoginPresenter") {
            context("valid data") {
                it("login success") {
                    let presenter = LoginPresenter(loginInteractor: MockLoginInteractor(mode: .success))
                    let loginViewRobot = LoginViewRobot(loginPresenter: presenter)
                    loginViewRobot.emitInputData(inputData: InputData(email: "matdziu@gmail.com", password: "qwerty"))
                    loginViewRobot.assert(expectedViewStates: [
                        LoginViewState(),
                        LoginViewState(progress: true),
                        LoginViewState(progress: true, loginSuccess: true)])
                }
                
                it("login error") {
                    let presenter = LoginPresenter(loginInteractor: MockLoginInteractor(mode: .error))
                    let loginViewRobot = LoginViewRobot(loginPresenter: presenter)
                    loginViewRobot.emitInputData(inputData: InputData(email: "matdziu@gmail.com", password: "qwerty"))
                    loginViewRobot.assert(expectedViewStates: [
                        LoginViewState(),
                        LoginViewState(progress: true),
                        LoginViewState(error: true)])
                }
            }
            
            context("invalid data") {
                it("email and password are shown as invalid") {
                    let presenter = LoginPresenter(loginInteractor: MockLoginInteractor(mode: .success))
                    let loginViewRobot = LoginViewRobot(loginPresenter: presenter)
                    loginViewRobot.emitInputData(inputData: InputData(email: "", password: ""))
                    loginViewRobot.assert(expectedViewStates: [
                        LoginViewState(),
                        LoginViewState(emailValid: false, passwordValid: false)])
                }
            }
        }
    }
}
