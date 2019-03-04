//
//  ViewControllerExtensions.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 29/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        
        let duration: Double = 2
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }
    
    func showAlertWithOkButton(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    func showAddGameViewController(completionHandler: @escaping (String) -> Void) {
        guard let addGameViewController = storyboard?.instantiateViewController(withIdentifier: ADD_GAME_VIEW_CONTROLLER_ID)
            as? AddGameViewController else { return }
        addGameViewController.providesPresentationContextTransitionStyle = true
        addGameViewController.definesPresentationContext = true
        addGameViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addGameViewController.completionHandler = completionHandler
        present(addGameViewController, animated: true, completion: nil)
    }
}
