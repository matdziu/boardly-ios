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
                
                expect(output).to(equal([PartialLoginViewState.loginSuccess]))
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
        }
    }
}
