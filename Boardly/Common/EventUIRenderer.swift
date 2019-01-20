//
//  EventUIRenderer.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 20/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class EventUIRenderer {
    
    func displayEventInfo(event: BoardlyEvent,
                          eventNameLabel: UILabel,
                          gameLabel: UILabel,
                          placeButton: UIButton,
                          locationImageView: UIImageView,
                          boardGameImageView: UIImageView,
                          seeDescriptionButton: UIButton,
                          dateButton: UIButton,
                          timeImageView: UIImageView,
                          gameLabel2: UILabel,
                          boardGameImageView2: UIImageView,
                          gameLabel3: UILabel,
                          boardGameImageView3: UIImageView) {
        eventNameLabel.text = event.eventName
        placeButton.setTitle(event.placeName, for: .normal)
        
        displayGameNameAndImage(gameName: event.gameName, gameLabel: gameLabel, gameImageUrl: event.gameImageUrl, gameImageView: boardGameImageView)
        displayGameNameAndImage(gameName: event.gameName2, gameLabel: gameLabel2, gameImageUrl: event.gameImageUrl2, gameImageView: boardGameImageView2)
        displayGameNameAndImage(gameName: event.gameName3, gameLabel: gameLabel3, gameImageUrl: event.gameImageUrl3, gameImageView: boardGameImageView3)
        
        setSeeDescriptionButton(description: event.description, seeDescriptionButton: seeDescriptionButton)
        setDateTextView(timestamp: event.timestamp, dateButton: dateButton)
    }
    
    private func displayGameNameAndImage(gameName: String, gameLabel: UILabel,
                                         gameImageUrl: String, gameImageView: UIImageView) {
        if (!gameName.isEmpty) {
            gameLabel.isHidden = false
            gameImageView.isHidden = false
            gameLabel.text = gameName
            gameImageView.downloaded(from: gameImageUrl)
        } else {
            gameLabel.isHidden = true
            gameImageView.isHidden = true
        }
    }
    
    private func setSeeDescriptionButton(description: String, seeDescriptionButton: UIButton) {
        if (!description.isEmpty) {
            seeDescriptionButton.isHidden = false
        } else {
            seeDescriptionButton.isHidden = true
        }
    }
    
    private func setDateTextView(timestamp: Int64, dateButton: UIButton) {
        if (timestamp > 0) {
            dateButton.setTitle(Date(timeIntervalSince1970: TimeInterval(timestamp / 1000)).formatForDisplay(), for: .normal)
        } else {
            dateButton.setTitle("To be added", for: .normal)
        }
    }
}
