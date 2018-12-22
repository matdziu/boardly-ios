//
//  LoginContract.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth
import FBSDKCoreKit

protocol LoginView {
    
    func render(loginViewState: LoginViewState)
    
    func inputEmitter() -> Observable<InputData>
    
    func googleSignInCredentialEmitter() -> Observable<AuthCredential>
    
    func facebookAccessTokenEmitter() -> Observable<FBSDKAccessToken>
}

protocol LoginInteractor {
    
    func login(email: String, password: String) -> Observable<PartialLoginViewState>
    
    func login(credential: AuthCredential) -> Observable<PartialLoginViewState>
    
    func login(token: FBSDKAccessToken) -> Observable<PartialLoginViewState>
}

protocol LoginService {
    
    func login(email: String, password: String) -> Observable<Bool>
    
    func login(credential: AuthCredential) -> Observable<Bool>
}
