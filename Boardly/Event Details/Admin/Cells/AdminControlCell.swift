//
//  AdminControlCell.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 07/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class AdminControlCell: UITableViewCell {
    
    @IBOutlet weak var editEventButton: UIButton!
    
    func bind(editEventHandler: @escaping () -> ()) {
        editEventButton.userInfo[EDIT_EVENT_HANDLER_USER_INFO] = editEventHandler
        editEventButton.addTarget(self, action: #selector(editEventButtonClicked(_:)), for: .touchUpInside)
    }
    
    @objc private func editEventButtonClicked(_ sender: UIButton) {
        let editEventButtonHandler = sender.userInfo[EDIT_EVENT_HANDLER_USER_INFO] as? () -> () ?? {}
        editEventButtonHandler()
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        
    }
}
