//
//  AdminPendingPlayerCell.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 07/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class AdminPendingPlayerCell: UITableViewCell {
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerPicture: UIImageView!
    @IBOutlet weak var playerRatingLabel: UILabel!
    @IBOutlet weak var helloTextLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var playerRatingImage: UIImageView!
    
    private var playerUIRenderer = PlayerUIRenderer()
    
    func bind(player: Player, acceptButtonHandler: @escaping (String) -> ()) {
        playerUIRenderer.displayPlayerInfo(player: player,
                                           playerImageView: playerPicture,
                                           nameLabel: playerNameLabel,
                                           helloTextLabel: helloTextLabel,
                                           ratingLabel: playerRatingLabel,
                                           ratingImageView: playerRatingImage)
        acceptButton.userInfo[ACCEPT_BUTTON_HANDLER_USER_INFO] = acceptButtonHandler
        acceptButton.userInfo[ACCEPTED_PLAYER_ID_USER_INFO] = player.id
        acceptButton.addTarget(self, action: #selector(acceptButtonClicked(_:)), for: .touchUpInside)
    }
    
    @objc private func acceptButtonClicked(_ sender: UIButton) {
        let acceptButtonHandler = sender.userInfo[ACCEPT_BUTTON_HANDLER_USER_INFO] as? (String) -> () ?? { _ in }
        let acceptedPlayerId = sender.userInfo[ACCEPTED_PLAYER_ID_USER_INFO] as? String ?? ""
        acceptButtonHandler(acceptedPlayerId)
    }
}
