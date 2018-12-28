//
//  ViewControllerUtils.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 28/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

func showErrorAlert(errorMessage: String, controller: UIViewController) {
    let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
    controller.present(alert, animated: true)
    
    let duration: Double = 2
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
        alert.dismiss(animated: true)
    }
}
