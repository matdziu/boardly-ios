//
//  RoundEdgesLabel.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 04/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class RoundEdgesLabel: UILabel {
    
    private var inset: CGFloat = 7.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: inset, left: inset, bottom: inset, right: inset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + inset + inset,
                      height: size.height + inset + inset)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = 10
    }
}
