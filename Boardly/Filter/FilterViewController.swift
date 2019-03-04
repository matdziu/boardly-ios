//
//  FilterViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 28/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import CoreLocation

class FilterViewController: BaseNavViewController, FilterView {
    
    private var gameIdSubject: PublishSubject<String>!
    private var locationProcessingSubject: PublishSubject<Bool>!
    private let distanceLabelDefaultText = NSLocalizedString("Maximum event distance:", comment: "")
    private var currentFilter = Filter()
    private var fetchDetails = true
    
    @IBOutlet weak var maxEventDistanceLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var useCurrentLocationButton: UIButton!
    
    private let filterPresenter = FilterPresenter(filterInteractor: FilterInteractorImpl(gameService: GameServiceImpl()))
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let locationManager = CLLocationManager()
    private var fromLocationPermission = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        getFilterFromDefaults()
        initDistanceFilter(radius: currentFilter.radius)
        initLocationFilter(locationName: currentFilter.locationName)
    }
    
    private func initDistanceFilter(radius: Double) {
        distanceSlider.value = Float(radius)
        maxEventDistanceLabel.text = "\(distanceLabelDefaultText) \(Int(radius))km"
    }
    
    private func initLocationFilter(locationName: String) {
        if !locationName.isEmpty {
            placeNameLabel.text = locationName
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let value = sender.value
        maxEventDistanceLabel.text = "\(distanceLabelDefaultText) \(Int(value))km"
        currentFilter.radius = Double(value)
    }
    
    @IBAction func applyButtonClicked(_ sender: Any) {
        saveFilterToDefaults()
        guard let mainTabViewController = self.navigationController?.viewControllers[0] as? MainTabViewController else { return }
        self.navigationController?.popViewController(animated: true)
        mainTabViewController.selectedIndex = 0
        (mainTabViewController.selectedViewController as? HomeViewController)?.fromFilter = true
    }
    
    @IBAction func pickPlaceButtonClicked(_ sender: Any) {
        guard let pickPlaceViewController = storyboard?.instantiateViewController(withIdentifier: PICK_PLACE_VIEW_CONTROLLER_ID) as? PickPlaceViewController else { return }
        pickPlaceViewController.finishAction = { placeSearchResult in
            let userLocation = UserLocation(latitude: placeSearchResult.latitude, longitude: placeSearchResult.longitude)
            let locationName = placeSearchResult.name
            self.currentFilter.userLocation = userLocation
            self.currentFilter.locationName = locationName
            self.currentFilter.isCurrentLocation = false
            self.placeNameLabel.text = locationName
        }
        self.navigationController?.pushViewController(pickPlaceViewController, animated: true)
    }
    
    @IBAction func useCurrentLocationButtonClicked(_ sender: Any) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            fromLocationPermission = true
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            showAlertWithOkButton(message: NSLocalizedString("Enable location for Boardly in settings of your phone. This allows us to show you board game events nearby.", comment: ""))
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
            locationProcessingSubject.onNext(true)
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        filterPresenter.bind(filterView: self)
        if fetchDetails {
            fetchDetails = false
            gameIdSubject.onNext(currentFilter.gameId)
        }
    }
    
    private func initEmitters() {
        gameIdSubject = PublishSubject<String>()
        locationProcessingSubject = PublishSubject<Bool>()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        filterPresenter.unbind()
        super.viewWillDisappear(animated)
    }
    
    func gameIdEmitter() -> Observable<String> {
        return gameIdSubject
    }
    
    func locationProcessingEmitter() -> Observable<Bool> {
        return locationProcessingSubject
    }
    
    func render(filterViewState: FilterViewState) {
        if filterViewState.locationProcessing {
            placeNameLabel.text = NSLocalizedString("Setting your location...", comment: "")
            useCurrentLocationButton.isUserInteractionEnabled = false
        } else {
            useCurrentLocationButton.isUserInteractionEnabled = true
        }
    }
    
    func handlePickGameResult(pickedGame: SearchResult) {
        currentFilter.gameName = pickedGame.name
        if pickedGame.type == RPG_TYPE {
            currentFilter.gameId = "\(pickedGame.id)\(RPG_TYPE)"
        } else {
            currentFilter.gameId = pickedGame.id
        }
        fetchDetails = true
    }
    
    private func saveFilterToDefaults() {
        if let savedFilterData = try? encoder.encode(currentFilter) {
            UserDefaults.standard.set(savedFilterData, forKey: SAVED_FILTER)
        }
    }
    
    private func getFilterFromDefaults() {
        if let savedFilterData = UserDefaults.standard.object(forKey: SAVED_FILTER) as? Data {
            if let savedFilter = try? decoder.decode(Filter.self, from: savedFilterData) {
                currentFilter = savedFilter
            }
        }
    }
}

extension FilterViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let rawLocation = locations.last else { return }
        let userLocation = UserLocation(latitude: rawLocation.coordinate.latitude, longitude: rawLocation.coordinate.longitude)
        currentFilter.userLocation = userLocation
        currentFilter.locationName = NSLocalizedString("Current location", comment: "")
        currentFilter.isCurrentLocation = true
        placeNameLabel.text = NSLocalizedString("Current location", comment: "")
        locationProcessingSubject.onNext(false)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedWhenInUse || status == .authorizedAlways) && fromLocationPermission {
            locationManager.requestLocation()
            locationProcessingSubject.onNext(true)
        } else if status == .denied {
            fromLocationPermission = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(message: NSLocalizedString("Something went wrong :(", comment: ""))
    }
}
