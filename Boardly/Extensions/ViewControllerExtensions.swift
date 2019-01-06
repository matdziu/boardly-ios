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
    
    func showErrorAlert(errorMessage: String) {
        let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        self.present(alert, animated: true)
        
        let duration: Double = 2
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }
    
    func showErrorAlertWithOkButton(errorMessage: String) {
        let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
}
