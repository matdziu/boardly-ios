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
    
    @IBInspectable
    var maxCharacters: Int = 0
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        delegate = self
    }
    
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if maxCharacters > 0 {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.count
            return numberOfChars < maxCharacters
        }
        return true
    }
}
