//
//  AdminViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 01/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class AdminViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    @IBOutlet weak var contentTableView: UITableView!
    
    private let adminPresenter = AdminPresenter(adminInteractor: AdminInteractorImpl(adminService: AdminServiceImpl()))
}
