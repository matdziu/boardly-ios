//
//  BoardlyEventCell.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 17/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class BoardlyEventCell: UITableViewCell {
    
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
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var acceptedLabel: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!
    
    private let renderer = EventUIRenderer()
    
    func bind(event: BoardlyEvent) {
        selectionStyle = .none
        renderer.displayEventInfo(event: event, eventNameLabel: nameLabel, gameLabel: game1NameLabel, placeButton: placeButton, locationImageView: placeImageView, boardGameImageView: game1ImageView, seeDescriptionButton: descriptionButton, dateButton: dateButton, timeImageView: timeImageView, gameLabel2: game2NameLabel, boardGameImageView2: game2ImageView, gameLabel3: game3NameLabel, boardGameImageView3: game3ImageView)
        setTypeLabel(type: event.type)
    }
    
    private func setTypeLabel(type: EventType) {
        switch type {
        case .CREATED:
            makeVisibleOnly(selectedView: createdLabel)
        case .ACCEPTED:
            makeVisibleOnly(selectedView: acceptedLabel)
        case .PENDING:
            makeVisibleOnly(selectedView: pendingLabel)
        case .DEFAULT:
            makeVisibleOnly(selectedView: joinButton)
        }
    }
    
    private func makeVisibleOnly(selectedView: UIView) {
        let viewsList = [joinButton, createdLabel, acceptedLabel, pendingLabel]
        for view in viewsList {
            if selectedView == view {
                view?.isHidden = false
            } else {
                view?.isHidden = true
            }
        }
    }
}
