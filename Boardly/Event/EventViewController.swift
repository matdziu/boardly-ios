//
//  EventViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 12/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import GooglePlaces

class EventViewController: UIViewController, EventView {
    
    private let eventPresenter = EventPresenter(eventInteractor: EventInteractorImpl(gameService: GameServiceImpl(), eventService: EventServiceImpl()))
    private var inputData = EventInputData()
    @IBOutlet weak var gameLabel1: UILabel!
    @IBOutlet weak var gameLabel2: UILabel!
    @IBOutlet weak var gameLabel3: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        eventPresenter.bind(eventView: self)
    }
    
    private func initEmitters() {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        eventPresenter.unbind()
        super.viewWillDisappear(animated)
    }
    
    @IBAction func pickPlaceButtonClicked(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func addEventEmitter() -> Observable<EventInputData> {
        return Observable.empty()
    }
    
    func editEventEmitter() -> Observable<EventInputData> {
        return Observable.empty()
    }
    
    func deleteEventEmitter() -> Observable<String> {
        return Observable.empty()
    }
    
    func gamePickEventEmitter() -> Observable<GamePickEvent> {
        return Observable.empty()
    }
    
    func placePickEventEmitter() -> Observable<Bool> {
        return Observable.empty()
    }
    
    func render(eventViewState: EventViewState) {
        
    }
}

extension EventViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let latitude = place.coordinate.latitude
        let longitude = place.coordinate.longitude
        let locationName = place.formattedAddress ?? place.name
        inputData.placeLatitude = latitude
        inputData.placeLongitude = longitude
        inputData.placeName = locationName
        placeLabel.text = locationName
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        dismiss(animated: true, completion: nil)
        showErrorAlert(errorMessage: "Something went wrong :(")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
