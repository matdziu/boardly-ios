//
//  CollectionGameCell.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 24/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import UIKit

class CollectionGameCell: UITableViewCell {
    
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var yearPublishedLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gameImageView.cancel()
        gameImageView.image = UIImage(named: Image.boardGamePlaceholder.rawValue)
    }
    
    func bind(game: CollectionGame) {
        gameNameLabel.text = game.name
        yearPublishedLabel.text = game.yearPublished
        gameImageView.downloaded(from: game.imageUrl, placeHolder: UIImage(named: Image.boardGamePlaceholder.rawValue))
    }
}
