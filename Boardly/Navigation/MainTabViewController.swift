//
//  MainTabViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 28/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class MainTabViewController: UITabBarController {
    
    private let logo = UIImage(named: Image.logo.rawValue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(named: Color.primaryBlue.rawValue)
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.titleView = UIImageView(image: logo)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = ""
    }
}
