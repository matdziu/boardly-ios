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
    
    @IBOutlet weak var leaveEventButton: UIButton!
    
    func bind(leaveEventHandler: @escaping () -> ()) {
        leaveEventButton.userInfo[LEAVE_BUTTON_HANDLER_USER_INFO] = leaveEventHandler
        leaveEventButton.addTarget(self, action: #selector(leaveButtonClicked(_:)), for: .touchUpInside)
    }
    
    @objc private func leaveButtonClicked(_ sender: UIButton) {
        let leaveHandler = sender.userInfo[LEAVE_BUTTON_HANDLER_USER_INFO] as? () -> () ?? {}
        guard let rootViewController = UIApplication
            .shared
            .keyWindow?
            .rootViewController
            else { return }
        let alert = UIAlertController(title: nil, message: "Are you sure you want to leave this event?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Leave now", style: .default, handler: { (action: UIAlertAction!) in
            leaveHandler()
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true)
        }))
        rootViewController.present(alert, animated: true)
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        
    }
}
