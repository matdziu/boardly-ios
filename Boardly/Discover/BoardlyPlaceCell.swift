//
//  PlaceCell.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 24/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import UIKit

class BoardlyPlaceCell: UITableViewCell {
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeDescription: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var browseBoardGamesButton: UIButton!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var createEventButton: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        placeImageView.cancel()
        placeImageView.image = UIImage(named: Image.placePlaceHolder.rawValue)
    }
    
    func bind(place: BoardlyPlace) {
        placeNameLabel.text = place.name
        placeDescription.text = place.description
        locationNameLabel.text = place.locationName
        placeImageView.downloaded(from: place.imageUrl, placeHolder: UIImage(named: Image.placePlaceHolder.rawValue))
    }
}
