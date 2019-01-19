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
    var maxHeight: CGFloat = 100.0
    
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
    
    func textViewDidChange(_ textView: UITextView) {
//        if isScrollEnabled {
//            let fixedWidth = frame.size.width
//            let newSize = sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//            textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
//        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor(named: borderColor.rawValue)?.cgColor
        layer.borderWidth = 1.0
        clipsToBounds = true
        layer.cornerRadius = 10.0
        if maxHeight > 0 && bounds.size.height >= maxHeight {
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
