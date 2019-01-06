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
    private let distanceLabelDefaultText = "Maximum event distance:"
    private var currentFilter = Filter()
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var maxEventDistanceLabel: UILabel!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    
    private let filterPresenter = FilterPresenter(filterInteractor: FilterInteractorImpl(gameService: GameServiceImpl()))
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func deleteGameButtonClicked(_ sender: Any) {
        gameImageView.cancelAll()
        gameNameLabel.text = "No game picked"
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
    }
    
    @IBAction func pickPlaceButtonClicked(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        filterPresenter.bind(filterView: self)
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
