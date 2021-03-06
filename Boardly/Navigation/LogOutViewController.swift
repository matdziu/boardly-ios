//
//  LogOutViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 28/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class LogOutViewController: BaseNavViewController {
    
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        signOut()
    }
    
    private func signOut() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if appDelegate.online {
                do {
                    try Auth.auth().signOut()
                    InstanceID.instanceID().deleteID { _ in }
                    goToLoginScreen()
                } catch {
                    navigationController?.popViewController(animated: true)
                    showAlert(message: NSLocalizedString("Something went wrong :(", comment: ""))
                }
            } else {
                navigationController?.popViewController(animated: true)
                showAlert(message: NSLocalizedString("You must be connected to the internet", comment: ""))
            }
        }
    }
    
    private func goToLoginScreen() {
        guard let loginViewController = storyboard?.instantiateViewController(withIdentifier: LOGIN_VIEW_CONTROLLER_ID) as? LoginViewController else { return }
        navigationController?.setViewControllers([loginViewController], animated: true)
    }
}
