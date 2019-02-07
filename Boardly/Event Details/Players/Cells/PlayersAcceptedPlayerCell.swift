//
//  AcceptedPlayerCell.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 05/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class PlayersAcceptedPlayerCell: UITableViewCell {
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerPicture: UIImageView!
    @IBOutlet weak var playerRatingLabel: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var helloTextLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    private var ratingPlayerUIRenderer = RatingPlayerUIRenderer()
    
    func bind(player: Player, pickRatingHandler: @escaping (Int) -> ()) {
        ratingPlayerUIRenderer.displayPlayerInfo(
            player: player,
            playerImageView: playerPicture,
            nameLabel: playerNameLabel,
            helloTextLabel: helloTextLabel,
            ratingLabel: playerRatingLabel,
            ratingImageView: ratingImageView,
            rateButton: rateButton,
            pickedRatingHandler: pickRatingHandler)
    }
}
