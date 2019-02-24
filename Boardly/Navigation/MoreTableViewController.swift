//
//  MoreTabViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 28/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class MoreTableViewController: UITableViewController {
    
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var yourProfileImageView: UIImageView!
    @IBOutlet weak var logOutImageView: UIImageView!
    @IBOutlet weak var myEventsImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTintColor(imageView: filterImageView)
        changeTintColor(imageView: yourProfileImageView)
        changeTintColor(imageView: logOutImageView)
        changeTintColor(imageView: myEventsImageView)
    }
    
    private func changeTintColor(imageView: UIImageView) {
        imageView.image = imageView.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imageView.tintColor = UIColor(named: Color.primaryBlue.rawValue)
    }
}
