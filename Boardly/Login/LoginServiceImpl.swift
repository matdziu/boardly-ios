//
//  LoginServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth

class LoginServiceImpl: LoginService {
    
    func login(email: String, password: String) -> Observable<Bool> {
        let resultSubject = PublishSubject<Bool>()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                resultSubject.onError(error)
                return
            }
            if user != nil {
                resultSubject.onNext(true)
            } else {
                resultSubject.onError(DefaultAuthError())
            }
        }
        return resultSubject
    }
}

