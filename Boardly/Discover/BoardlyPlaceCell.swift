//
//  PlaceCell.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 24/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import UIKit
import MapKit

class BoardlyPlaceCell: UITableViewCell {
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeDescription: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var browseBoardGamesButton: UIButton!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var createEventButton: UIButton!
    
    private var place: BoardlyPlace!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        placeImageView.cancel()
        placeImageView.image = UIImage(named: Image.placePlaceHolder.rawValue)
    }
    
    @IBAction func call(_ sender: Any) {
        if let url = URL(string: "tel://\(place.phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func browseGames(_ sender: Any) {
    }
    
    @IBAction func createEvent(_ sender: Any) {
        guard let mainTabViewController = (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.viewControllers[0] as? MainTabViewController else { return }
        mainTabViewController.selectedIndex = 2
        guard let eventViewController = mainTabViewController.selectedViewController as? EventViewController else { return }
        eventViewController.clearButtonClicked(self)
        eventViewController.handlePickedPlace(latitude: place.placeLatitude, longitude: place.placeLongitude, locationName: place.locationName)
        eventViewController.prepare(mode: .add, successHandler: {
            mainTabViewController.selectedIndex = 0
            eventViewController.showAlert(message: NSLocalizedString("Everything went well!", comment: ""))
        })
    }
    
    func bind(place: BoardlyPlace) {
        self.place = place
        placeNameLabel.text = place.name
        placeDescription.text = place.description
        locationNameLabel.text = place.locationName
        placeImageView.downloaded(from: place.imageUrl, placeHolder: UIImage(named: Image.placePlaceHolder.rawValue))
        
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(openMapForPlace))
        locationNameLabel.addGestureRecognizer(locationTap)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openPlaceLink))
        placeImageView.addGestureRecognizer(imageTap)
    }
    
    @objc func openMapForPlace() {
        let regionDistance: CLLocationDistance = 5000
        let coordinates = CLLocationCoordinate2DMake(self.place.placeLatitude, self.place.placeLongitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.place.locationName
        mapItem.openInMaps(launchOptions: options)
    }
    
    
    @objc func openPlaceLink() {
        if let link = URL(string: place.pageLink), UIApplication.shared.canOpenURL(link) {
            UIApplication.shared.open(link)
        }
    }
}
