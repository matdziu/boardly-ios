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
import GooglePlaces

class FilterViewController: BaseNavViewController, FilterView {
    
    private var gameIdSubject: PublishSubject<String>!
    private var locationProcessingSubject: PublishSubject<Bool>!
    private let distanceLabelDefaultText = NSLocalizedString("Maximum event distance:", comment: "")
    private var currentFilter = Filter()
    private var fetchDetails = true
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var maxEventDistanceLabel: UILabel!
    @IBOutlet weak var gameNameLabel: UILabel!
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
        gameImageView.roundBorderCorners()
        initDistanceFilter(radius: currentFilter.radius)
        initGameFilter(gameName: currentFilter.gameName)
        initLocationFilter(locationName: currentFilter.locationName)
    }
    
    private func initDistanceFilter(radius: Double) {
        distanceSlider.value = Float(radius)
        maxEventDistanceLabel.text = "\(distanceLabelDefaultText) \(Int(radius))km"
    }
    
    private func initGameFilter(gameName: String) {
        if !gameName.isEmpty {
            gameNameLabel.text = gameName
        }
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
    
    @IBAction func pickGameButtonClicked(_ sender: Any) {
        guard let pickGameViewController = storyboard?.instantiateViewController(withIdentifier: PICK_GAME_VIEW_CONTROLLER_ID) as? PickGameViewController else { return }
        pickGameViewController.finishAction = { self.handlePickGameResult(pickedGame: $0) }
        self.navigationController?.pushViewController(pickGameViewController, animated: true)
    }
    
    @IBAction func deleteGameButtonClicked(_ sender: Any) {
        gameImageView.cancel()
        gameNameLabel.text = NSLocalizedString("No game picked", comment: "")
        currentFilter.gameId = ""
        currentFilter.gameName = ""
        gameImageView.image = UIImage(named: Image.boardGamePlaceholder.rawValue)
        gameIdSubject.onNext("")
    }
    
    @IBAction func applyButtonClicked(_ sender: Any) {
        saveFilterToDefaults()
        guard let mainTabViewController = self.navigationController?.viewControllers[0] as? MainTabViewController else { return }
        self.navigationController?.popViewController(animated: true)
        mainTabViewController.selectedIndex = 0
        (mainTabViewController.selectedViewController as? HomeViewController)?.fromFilter = true
    }
    
    @IBAction func pickPlaceButtonClicked(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
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
        gameImageView.downloaded(from: filterViewState.gameImageUrl, placeHolder: UIImage(named: Image.boardGamePlaceholder.rawValue))
        if filterViewState.locationProcessing {
            placeNameLabel.text = NSLocalizedString("Setting your location...", comment: "")
            useCurrentLocationButton.isUserInteractionEnabled = false
        } else {
            useCurrentLocationButton.isUserInteractionEnabled = true
        }
    }
    
    func handlePickGameResult(pickedGame: SearchResult) {
        gameNameLabel.text = pickedGame.name
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

extension FilterViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let userLocation = UserLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let locationName = place.formattedAddress ?? place.name
        currentFilter.userLocation = userLocation
        currentFilter.locationName = locationName
        currentFilter.isCurrentLocation = false
        placeNameLabel.text = locationName
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        dismiss(animated: true, completion: nil)
        showAlert(message: NSLocalizedString("Something went wrong :(", comment: ""))
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
