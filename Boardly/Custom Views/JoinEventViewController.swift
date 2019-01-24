//
//  JoinEventViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class JoinEventViewController: UIViewController {
    
    @IBOutlet weak var helloTextView: BoardlyTextView!
    var completionHandler: (String) -> Void = { _ in }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func joinButtonClicked(_ sender: Any) {
        let helloText = helloTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if helloText.isEmpty {
            helloTextView.showError(show: true)
        } else {
            helloTextView.showError(show: false)
            completionHandler(helloText)
            dismiss(animated: true, completion: nil)
        }
    }
}
