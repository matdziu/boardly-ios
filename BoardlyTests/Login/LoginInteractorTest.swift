//
//  LoginInteractorTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import Quick
import RxBlocking
import Nimble
@testable import Boardly

class LoginInteractorTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        describe("LoginInteractor") {
            it("produces success") {
                let loginInteractor = LoginInteractorImpl(loginService: MockLoginService(mode: .success))
                let output = try! loginInteractor.login(email: "matdziu@gmail.com", password: "qwerty")
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialLoginViewState.loginSuccess(isProfileFilled: true)]))
            }
            
            it("produces error") {
                let loginInteractor = LoginInteractorImpl(loginService: MockLoginService(mode: .error))
                let output = try! loginInteractor.login(email: "matdziu@gmail.com", password: "qwerty")
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([
                    PartialLoginViewState.errorState(error: DefaultAuthError() as NSError, dismiss: false),
                    PartialLoginViewState.errorState(error: DefaultAuthError() as NSError, dismiss: true)]))
            }
            
            it("detects logged in user with filled profile") {
                let loginInteractor = LoginInteractorImpl(loginService: MockLoginService(mode: .success, isProfileFilled: true, isLogged: true))
                let output = try! loginInteractor.isLoggedIn()
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([.loginSuccess(isProfileFilled: true)]))
            }
            
            it("detects that user is not logged in") {
                let loginInteractor = LoginInteractorImpl(loginService: MockLoginService(mode: .success, isProfileFilled: false, isLogged: false))
                let output = try! loginInteractor.isLoggedIn()
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([.notLoggedIn]))
            }
        }
    }
}
