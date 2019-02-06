//
//  SimpleHeader.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 06/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class SimpleHeader: UILabel {
    
    private var inset: CGFloat = 16.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.white
        textColor = UIColor(named: Color.grey.rawValue)
        font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0.0, left: inset, bottom: 0.0, right: 0.0)
        super.drawText(in: rect.inset(by: insets))
    }
}
