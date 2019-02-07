//
//  BoardlyDatePicker.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 14/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class BoardlyDatePicker: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var doneAction: (Date) -> Void = {_ in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("BoardlyDatePicker", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        datePicker.backgroundColor = UIColor.white
        datePicker.minimumDate = Date()
        doneButton.setTitle(NSLocalizedString("Done", comment: "").uppercased(), for: .normal)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "").uppercased(), for: .normal)
    }
    
    func show(show: Bool) {
        isHidden = !show
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        show(show: false)
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        doneAction(datePicker.date)
        show(show: false)
    }
}
