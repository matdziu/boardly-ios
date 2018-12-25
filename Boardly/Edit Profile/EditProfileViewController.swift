//
//  EditProfileViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 24/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class EditProfileViewController: BaseNavViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initProfileImageView()
    }
    
    private func initProfileImageView() {
        profileImageView.layer.borderColor = UIColor(named: Color.grey.rawValue)?.cgColor
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.cornerRadius = 3.0
    }
}
