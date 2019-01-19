//
//  BoardlyTextView.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import UIKit

class BoardlyTextView: UITextView, UITextViewDelegate {
    
    private var borderColor = Color.primaryBlue
    
    @IBInspectable
    var maxHeight: CGFloat = 0.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor(named: borderColor.rawValue)?.cgColor
        layer.borderWidth = 1.0
        clipsToBounds = true
        layer.cornerRadius = 10.0
        if maxHeight > 0 && contentSize.height >= maxHeight {
            isScrollEnabled = true
        } else {
            isScrollEnabled = false
        }
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
