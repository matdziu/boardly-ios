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
import FirebaseDatabase

class LoginServiceImpl: BaseServiceImpl, LoginService {
    
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
        return resultSubject.flatMap({ [unowned self] _ in return self.checkIfProfileIsFilled(userId: self.getCurrentUserId()) })
    }
    
    func login(credential: AuthCredential) -> Observable<Bool> {
        let resultSubject = PublishSubject<Bool>()
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            if let error = error {
                resultSubject.onError(error)
                return
            }
            if result != nil {
                resultSubject.onNext(true)
            } else {
                resultSubject.onError(DefaultAuthError())
            }
        }
        return resultSubject.flatMap({ [unowned self] _ in return self.checkIfProfileIsFilled(userId: self.getCurrentUserId()) })
    }
    
    func isLoggedIn() -> Observable<LoginData> {
        if (getCurrentUser() != nil) {
            return checkIfProfileIsFilled(userId: getCurrentUserId())
                .map({ (isProfilFilled) -> LoginData in
                    return LoginData(isLoggedIn: true, isProfileFilled: isProfilFilled)
                })
        } else {
            return Observable.just(LoginData(isLoggedIn: false, isProfileFilled: false))
        }
    }
    
    private func checkIfProfileIsFilled(userId: String) -> Observable<Bool> {
        let resultSubject = PublishSubject<Bool>()
        getUserNodeRef(userId: userId).observeSingleEvent(of: .value) { (snapshot) in
            resultSubject.onNext(snapshot.exists())
        }
        return resultSubject
    }
}
