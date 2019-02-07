//
//  AdminAcceptedPlayerCell.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 07/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class AdminAcceptedPlayerCell: UITableViewCell {
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerPicture: UIImageView!
    @IBOutlet weak var playerRatingLabel: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var helloTextLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var kickButton: UIButton!
    
    private var ratingPlayerUIRenderer = RatingPlayerUIRenderer()
    
    func bind(player: Player,
              pickRatingHandler: @escaping (Int) -> (),
              kickPlayerHandler: @escaping (String) -> ()) {
        ratingPlayerUIRenderer.displayPlayerInfo(
            player: player,
            playerImageView: playerPicture,
            nameLabel: playerNameLabel,
            helloTextLabel: helloTextLabel,
            ratingLabel: playerRatingLabel,
            ratingImageView: ratingImageView,
            rateButton: rateButton,
            pickedRatingHandler: pickRatingHandler)
        kickButton.userInfo[KICK_BUTTON_HANDLER_USER_INFO] = kickPlayerHandler
        kickButton.userInfo[KICKED_PLAYER_ID_USER_INFO] = player.id
        kickButton.addTarget(self, action: #selector(kickButtonClicked(_:)), for: .touchUpInside)
    }
    
    @objc private func kickButtonClicked(_ sender: UIButton) {
        let kickButtonHandler = sender.userInfo[KICK_BUTTON_HANDLER_USER_INFO] as? (String) -> () ?? { _ in }
        let kickedPlayerId = sender.userInfo[KICKED_PLAYER_ID_USER_INFO] as? String ?? ""
        kickButtonHandler(kickedPlayerId)
    }
}
