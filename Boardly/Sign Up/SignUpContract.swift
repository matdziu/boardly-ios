//
//  SignUpContract.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

protocol SignUpView {
    
    func render(signUpViewState: SignUpViewState)
    
    func inputEmitter() -> Observable<InputData>
}

protocol SignUpInteractor {
    
    func signUp(email: String, password: String) -> Observable<PartialSignUpViewState>
}

protocol SignUpService {
    func signUp(email: String, password: String) -> Observable<Bool>
}

