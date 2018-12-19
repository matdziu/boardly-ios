//
//  LoginContract.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

protocol LoginView {
    
    func render(loginViewState: LoginViewState)
    
    func inputEmitter() -> Observable<InputData>
}

protocol LoginInteractor {
    
    func login(email: String, password: String) -> Observable<PartialLoginViewState>
}

protocol LoginService {
    func login(email: String, password: String) -> Observable<Bool>
}
