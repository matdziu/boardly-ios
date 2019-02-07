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
    private var initialize = true
    
    private let loginManager = FBSDKLoginManager()
    var googleSignInCredentialSubject: PublishSubject<AuthCredential>!
    private var facebookAccessTokenSubject: PublishSubject<FBSDKAccessToken>!
    private var initialLoginCheckSubject: PublishSubject<Bool>!
    private let loginPresenter = LoginPresenter(loginInteractor: LoginInteractorImpl(loginService: LoginServiceImpl()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPrivacyPolicyOnClick()
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        loginPresenter.bind(loginView: self)
        initialLoginCheckSubject.onNext(initialize)
        initView()
    }
    
    private func initView() {
        if fbAccessToken != nil {
            facebookAccessTokenSubject.onNext(fbAccessToken!)
            fbAccessToken = nil
        }
    }
    
    private func initEmitters() {
        facebookAccessTokenSubject = PublishSubject()
        googleSignInCredentialSubject = PublishSubject()
        initialLoginCheckSubject = PublishSubject()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        initialize = false
        loginPresenter.unbind()
        super.viewWillDisappear(animated)
    }
    
    @IBAction func loginUsingGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func loginUsingFacebook(_ sender: Any) {
        loginManager.logIn(withReadPermissions: [ "email" ], from: self) { [unowned self] (loginResult, error) in
            if error != nil {
                self.showAlert(message: NSLocalizedString("Something went wrong :(", comment: ""))
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
    
    func initialLoginCheckEmitter() -> Observable<Bool> {
        return initialLoginCheckSubject
    }
    
    func render(loginViewState: LoginViewState) {
        showErrorLabel(show: !loginViewState.emailValid, label: emailLabel)
        showErrorLabel(show: !loginViewState.passwordValid, label: passwordLabel)
        emailTextField.showError(show: !loginViewState.emailValid)
        passwordTextField.showError(show: !loginViewState.passwordValid)
        showProgress(show: loginViewState.progress)
        showLoginError(error: loginViewState.error, errorMessage: loginViewState.errorMessage, dismissError: loginViewState.dismissError)
        
        if loginViewState.loginSuccess {
            guard let homeViewController = storyboard?.instantiateViewController(withIdentifier: MAIN_TAB_VIEW_CONTROLLER_ID) as? MainTabViewController else { return }
            guard let editProfileViewController = storyboard?.instantiateViewController(withIdentifier: EDIT_PROFILE_VIEW_CONTROLLER_ID) as? EditProfileViewController else { return }
            editProfileViewController.navigationItem.hidesBackButton = true
            
            if loginViewState.isProfileFilled {
                navigationController?.setViewControllers([homeViewController], animated: true)
            } else {
                navigationController?.setViewControllers([homeViewController, editProfileViewController], animated: true)
            }
        }
    }
    
    private func showLoginError(error: Bool, errorMessage: String, dismissError: Bool) {
        if error && !dismissError {
            showAlert(message: errorMessage)
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
