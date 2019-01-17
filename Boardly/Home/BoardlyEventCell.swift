//
//  BoardlyEventCell.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 17/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class BoardlyEventCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var game1NameLabel: UILabel!
    @IBOutlet weak var game2NameLabel: UILabel!
    @IBOutlet weak var game3NameLabel: UILabel!
    @IBOutlet weak var game1ImageView: UIImageView!
    @IBOutlet weak var game2ImageView: UIImageView!
    @IBOutlet weak var game3ImageView: UIImageView!
    @IBOutlet weak var placeButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var descriptionButton: UIButton!
}
