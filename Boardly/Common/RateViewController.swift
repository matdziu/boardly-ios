//
//  RateViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 05/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class RateViewController: UIViewController {
    
    private var rateButtonClickedHandler: (Int) -> () = { _ in }
    
    @IBOutlet weak var ratingView: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingView.rating = 3.0
    }
    
    func prepare(rateButtonClickedHandler: @escaping (Int) -> ()) {
        self.rateButtonClickedHandler = rateButtonClickedHandler
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateButtonClicked(_ sender: Any) {
        rateButtonClickedHandler(Int(ratingView.rating))
        dismiss(animated: true, completion: nil)
    }
}
