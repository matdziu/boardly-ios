//
//  PlayerUIRenderer.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 05/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class PlayerUIRenderer {
    
    func displayPlayerInfo(player: Player,
                           playerImageView: UIImageView,
                           nameLabel: UILabel,
                           helloTextLabel: UILabel,
                           ratingLabel: UILabel,
                           ratingImageView: UIImageView) {
        playerImageView.downloaded(from: player.profilePicture, placeHolder: UIImage(named: Image.profilePicturePlaceHolder.rawValue))
        nameLabel.text = player.name
        helloTextLabel.text = player.helloText
        displayRating(rating: player.rating, ratingLabel: ratingLabel, ratingImageView: ratingImageView)
    }
    
    private func displayRating(rating: Double?,
                               ratingLabel: UILabel,
                               ratingImageView: UIImageView) {
        if rating != nil {
            ratingImageView.isHidden = false
            ratingLabel.isHidden = false
            ratingLabel.text = String(format: "%.1f", rating!)
        } else {
            ratingImageView.isHidden = true
            ratingLabel.isHidden = true
        }
    }
}
