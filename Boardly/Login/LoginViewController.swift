//
//  LoginViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class LoginViewController: BaseNavViewController, LoginView, GIDSignInUIDelegate {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: BoardlyTextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: BoardlyTextField!
    @IBOutlet weak var loginButton: BoardlyButton!
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    private var fbAccessToken: FBSDKAccessToken? = nil
    
    private let loginManager = FBSDKLoginManager()
    let googleSignInCredentialSubject = PublishSubject<AuthCredential>()
    private let facebookAccessTokenSubject = PublishSubject<FBSDKAccessToken>()
    private let loginPresenter = LoginPresenter(loginInteractor: LoginInteractorImpl(loginService: LoginServiceImpl()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPrivacyPolicyOnClick()
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginPresenter.bind(loginView: self)
        if fbAccessToken != nil {
            facebookAccessTokenSubject.onNext(fbAccessToken!)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        loginPresenter.unbind()
        super.viewWillDisappear(animated)
    }
    
    @IBAction func loginUsingGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func loginUsingFacebook(_ sender: Any) {
        loginManager.logIn(withReadPermissions: [ "email" ], from: self) { [unowned self] (loginResult, error) in
            if error != nil {
                self.showErrorAlert(errorMessage: "Something went wrong :(")
                return
            }
            self.fbAccessToken = loginResult?.token
        }
    }
    
    func inputEmitter() -> Observable<InputData> {
        return loginButton
            .rx
            .controlEvent(UIControl.Event.touchUpInside)
            .map({ InputData(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "") })
    }
    
    func googleSignInCredentialEmitter() -> Observable<AuthCredential> {
        return googleSignInCredentialSubject
    }
    
    func facebookAccessTokenEmitter() -> Observable<FBSDKAccessToken> {
        return facebookAccessTokenSubject
    }
    
    func render(loginViewState: LoginViewState) {
        showErrorLabel(show: !loginViewState.emailValid, label: emailLabel)
        showErrorLabel(show: !loginViewState.passwordValid, label: passwordLabel)
        emailTextField.showError(show: !loginViewState.emailValid)
        passwordTextField.showError(show: !loginViewState.passwordValid)
        showProgress(show: loginViewState.progress)
        showLoginError(error: loginViewState.error, errorMessage: loginViewState.errorMessage, dismissError: loginViewState.dismissError)
        
        if loginViewState.loginSuccess {
            if let homeViewController = storyboard?.instantiateViewController(withIdentifier: HOME_VIEW_CONTROLLER_ID) as? HomeViewController {
                navigationController?.setViewControllers([homeViewController], animated: true)
            }
        }
    }
    
    private func showLoginError(error: Bool, errorMessage: String, dismissError: Bool) {
        if error && !dismissError {
            showErrorAlert(errorMessage: errorMessage)
        }
    }
    
    func showErrorAlert(errorMessage: String) {
        let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        present(alert, animated: true)
        
        let duration: Double = 2
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }
    
    private func showErrorLabel(show: Bool, label: UILabel) {
        if show {
            label.textColor = UIColor(named: Color.errorRed.rawValue)
        } else {
            label.textColor = UIColor(named: Color.grey.rawValue)
        }
    }
    
    private func showProgress(show: Bool) {
        if show {
            progressView.startAnimating()
        } else {
            progressView.stopAnimating()
        }
    }
    
    func initPrivacyPolicyOnClick() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(openPrivacyPolicyPage))
        privacyPolicyLabel.addGestureRecognizer(tap)
    }
    
    @objc func openPrivacyPolicyPage() {
        if let link = URL(string: "https://boardly.github.io/") {
            UIApplication.shared.open(link)
        }
    }
}
