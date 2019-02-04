//
//  ReceivedMessageCell.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 04/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class ReceivedMessageCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: RoundEdgesLabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profilePicture.cancel()
    }
    
    func bind(message: String,
              name: String,
              profilePictureUrl: String) {
        messageLabel.text = message
        nameLabel.text = name
        profilePicture.downloaded(from: profilePictureUrl)
    }
}
