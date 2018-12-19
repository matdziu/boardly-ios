//
//  BoardlyTextField.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import UIKit

class BoardlyTextField: UITextField {
    
    private var borderColor = Color.primaryBlue
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor(named: borderColor.rawValue)?.cgColor
        layer.borderWidth = 1.0
        clipsToBounds = true
        layer.cornerRadius = frame.size.height / 5.0
    }
    
    func showError(show: Bool) {
        if (show) {
            borderColor = Color.errorRed
        } else {
            borderColor = Color.primaryBlue
        }
        layer.borderColor = UIColor(named: borderColor.rawValue)?.cgColor
    }
}

