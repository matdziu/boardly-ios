//
//  RatingPlayerUIRenderer.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 05/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class RatingPlayerUIRenderer: PlayerUIRenderer {
    
    func displayPlayerInfo(player: Player,
                           playerImageView: UIImageView,
                           nameLabel: UILabel,
                           helloTextLabel: UILabel,
                           ratingLabel: UILabel,
                           ratingImageView: UIImageView,
                           rateButton: UIButton,
                           pickedRatingHandler:  @escaping (Int) -> ()) {
        super.displayPlayerInfo(player: player,
                                playerImageView: playerImageView,
                                nameLabel: nameLabel,
                                helloTextLabel: helloTextLabel,
                                ratingLabel: ratingLabel,
                                ratingImageView: ratingImageView)
        displayRateButton(ratedOrSelf: player.ratedOrSelf, rateButton: rateButton)
        rateButton.userInfo[PICKED_RATING_HANDLER_USER_INFO] = pickedRatingHandler
        rateButton.addTarget(self, action: #selector(launchRateDialog(_:)), for: .touchUpInside)
    }
    
    @objc private func launchRateDialog(_ sender: UIButton) {
        let pickedRatingHandler = sender.userInfo[PICKED_RATING_HANDLER_USER_INFO] as? (Int) -> () ?? { _ in }
    }
    
    private func displayRateButton(ratedOrSelf: Bool, rateButton: UIButton) {
        if ratedOrSelf {
            rateButton.isHidden = true
        }
        else {
            rateButton.isHidden = false
        }
    }
}
