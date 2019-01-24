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
    @IBOutlet weak var enterEventButton: UIButton!
    
    private let renderer = EventUIRenderer()
    
    private var cellClickAction = {}
    
    func bind(event: BoardlyEvent, cellClickAction: @escaping () -> Void = {}) {
        self.cellClickAction = cellClickAction
        selectionStyle = .none
        renderer.displayEventInfo(event: event, eventNameLabel: nameLabel, gameLabel: game1NameLabel, placeButton: placeButton, locationImageView: placeImageView, boardGameImageView: game1ImageView, seeDescriptionButton: descriptionButton, dateButton: dateButton, timeImageView: timeImageView, gameLabel2: game2NameLabel, boardGameImageView2: game2ImageView, gameLabel3: game3NameLabel, boardGameImageView3: game3ImageView)
        setType(type: event.type)
        joinButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        enterEventButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    @objc private func buttonClicked() {
        cellClickAction()
    }
    
    private func setType(type: EventType) {
        switch type {
        case .CREATED:
            enterEventButton.isHidden = false
            makeVisibleOnly(selectedView: createdLabel)
        case .ACCEPTED:
            enterEventButton.isHidden = false
            makeVisibleOnly(selectedView: acceptedLabel)
        case .PENDING:
            enterEventButton.isHidden = true
            makeVisibleOnly(selectedView: pendingLabel)
        case .DEFAULT:
            enterEventButton.isHidden = true
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
