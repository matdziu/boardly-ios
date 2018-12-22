//
//  MockLoginView.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth
@testable import Boardly

class MockLoginView: LoginView {
    let inputDataSubject = PublishSubject<InputData>()
    let googleSignInCredentialSubject = PublishSubject<AuthCredential>()
    var renderedStates: [LoginViewState] = []
    
    func inputEmitter() -> Observable<InputData> {
        return inputDataSubject
    }
    
    func googleSignInCredentialEmitter() -> Observable<AuthCredential> {
        return googleSignInCredentialSubject
    }
    
    func render(loginViewState: LoginViewState) {
        renderedStates.append(loginViewState)
    }
}


