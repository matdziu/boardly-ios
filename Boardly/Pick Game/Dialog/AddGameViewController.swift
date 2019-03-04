//
//  AddGameViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 04/03/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class AddGameViewController: UIViewController {
    
    @IBOutlet weak var gameNameTextView: BoardlyTextView!
    
    var completionHandler: (String) -> Void = { _ in }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let gameName = gameNameTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if gameName.isEmpty {
            gameNameTextView.showError(show: true)
        } else {
            gameNameTextView.showError(show: false)
            completionHandler(gameName)
            dismiss(animated: true, completion: nil)
        }
    }
}
