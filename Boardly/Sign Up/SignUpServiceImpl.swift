//
//  SignUpServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth

class SignUpServiceImpl: SignUpService {
    
    func signUp(email: String, password: String) -> Observable<Bool> {
        let resultSubject = PublishSubject<Bool>()
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                resultSubject.onError(error)
                return
            }
            if authResult != nil {
                resultSubject.onNext(true)
            } else {
                resultSubject.onError(DefaultAuthError())
            }
        }
        return resultSubject
    }
}
