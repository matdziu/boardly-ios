//
//  LoginPresenter.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth
import FBSDKLoginKit

class LoginPresenter {
    
    private let loginInteractor: LoginInteractor
    private var disposeBag = DisposeBag()
    private let stateSubject: BehaviorSubject<LoginViewState>
    
    init(loginInteractor: LoginInteractor, initialViewState: LoginViewState = LoginViewState()) {
        self.loginInteractor = loginInteractor
        self.stateSubject = BehaviorSubject(value: initialViewState)
    }
    
    func bind(loginView: LoginView) {
        let inputDataObservable = loginView.inputEmitter()
            .flatMap { (inputData: InputData) -> Observable<PartialLoginViewState> in
                let trimmedEmail = inputData.email.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedPassword = inputData.password.trimmingCharacters(in: .whitespacesAndNewlines)
                
                let emailValid = !trimmedEmail.isEmpty
                let passwordValid = !trimmedPassword.isEmpty
                
                if !emailValid || !passwordValid {
                    return Observable.just(.localValidation(emailValid: emailValid, passwordValid: passwordValid))
                } else {
                    return self.loginInteractor.login(email: trimmedEmail, password: trimmedPassword).startWith(.progress)
                }
        }
        
        let googleSignInCredentialObservable = loginView.googleSignInCredentialEmitter()
            .flatMap { [unowned self] (credential: AuthCredential) -> Observable<PartialLoginViewState> in
                return self.loginInteractor.login(credential: credential).startWith(.progress)
        }
        
        let facebookAccessTokenObservable = loginView.facebookAccessTokenEmitter()
            .flatMap { [unowned self] (token: FBSDKAccessToken) -> Observable<PartialLoginViewState> in
                return self.loginInteractor.login(token: token).startWith(.progress)
        }
        
        let initialLoginCheckObservable = loginView.initialLoginCheckEmitter()
            .filter({ return $0 })
            .flatMap { [unowned self] _ in return self.loginInteractor.isLoggedIn().startWith(.progress) }
        
        Observable
            .merge([inputDataObservable, googleSignInCredentialObservable, facebookAccessTokenObservable, initialLoginCheckObservable])
            .scan(try! stateSubject.value()) { (viewState: LoginViewState, partialState: PartialLoginViewState) -> LoginViewState in
                return self.reduce(previousState: viewState, partialState: partialState)
            }
            .observeOn(MainScheduler.instance)
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
        
        stateSubject
            .subscribe (onNext: {(viewState: LoginViewState) in
                loginView.render(loginViewState: viewState)
            })
            .disposed(by: disposeBag)
    }
    
    func unbind() {
        disposeBag = DisposeBag()
    }
    
    private func reduce(previousState: LoginViewState, partialState: PartialLoginViewState) -> LoginViewState {
        return partialState.reduce(previousState: previousState)
    }
}

