//
//  PlayerControlCell.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 05/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class PlayerControlCell: UITableViewCell {
    
    @IBOutlet weak var chatNotificationsSwitch: UISwitch!
    @IBOutlet weak var leaveEventButton: UIButton!
    
    func bind(leaveEventHandler: () -> ()) {
        
    }
}
