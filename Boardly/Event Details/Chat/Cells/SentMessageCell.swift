//
//  SentMessageCell.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 04/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class SentMessageCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: RoundEdgesLabel!
    
    func bind(message: String, isSent: Bool) {
        messageLabel.text = message
        if isSent {
            changeBackgroudTo(.primaryBlue)
        } else {
            changeBackgroudTo(.primaryBlueDim)
        }
    }
    
    private func changeBackgroudTo(_ color: Color) {
        messageLabel.backgroundColor = UIColor(named: color.rawValue)
    }
}
