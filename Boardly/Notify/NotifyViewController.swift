//
//  NotifyViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 24/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import GooglePlaces

class NotifyViewController: UIViewController, NotifyView {
    
    private var gameIdSubject: PublishSubject<String>!
    private var notifySettingsFetchSubject: PublishSubject<Bool>!
    private var placePickEventSubject: PublishSubject<Bool>!
    @IBOutlet weak var eventDistanceLabel: UILabel!
    @IBOutlet weak var eventDistanceSlider: UISlider!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    
    private var initialize = true
    private var newSettings = NotifySettings()
    
    private let notifyPresenter = NotifyPresenter(notifyInteractor: NotifyInteractorImpl(gameService: GameServiceImpl(), notifyService: NotifyServiceImpl()))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        notifyPresenter.bind(notifyView: self)
    }
    
    private func initEmitters() {
        gameIdSubject = PublishSubject()
        notifySettingsFetchSubject = PublishSubject()
        placePickEventSubject = PublishSubject()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        initialize = false
        notifyPresenter.unbind()
        super.viewWillDisappear(animated)
    }
    
    func gameIdEmitter() -> Observable<String> {
        return gameIdSubject
    }
    
    func notifySettingsEmitter() -> Observable<NotifySettings> {
        // rxcocoa here
        return Observable.empty()
    }
    
    func notifySettingsFetchEmitter() -> Observable<Bool> {
        return notifySettingsFetchSubject
    }
    
    func stopNotificationsButtonClickEmitter() -> Observable<Bool> {
        // rxcocoa here
        return Observable.empty()
    }
    
    func placePickEventEmitter() -> Observable<Bool> {
        return placePickEventSubject
    }
    @IBAction func pickGameButtonClicked(_ sender: Any) {
        guard let pickGameViewController = storyboard?.instantiateViewController(withIdentifier: PICK_GAME_VIEW_CONTROLLER_ID) as? PickGameViewController else { return }
        pickGameViewController.finishAction = { self.handlePickGameResult(pickedGame: $0) }
        self.navigationController?.pushViewController(pickGameViewController, animated: true)
    }
    
    private func handlePickGameResult(pickedGame: SearchResult) {
        
    }
    
    @IBAction func pickPlaceButtonClicked(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func deleteGameButtonClicked(_ sender: Any) {
    }
    
    func render(notifyViewState: NotifyViewState) {
        
    }
}

extension NotifyViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        newSettings.userLatitude = place.coordinate.latitude
        newSettings.userLongitude = place.coordinate.longitude
        let locationName = place.formattedAddress ?? place.name
        newSettings.locationName = locationName
        placeNameLabel.text = locationName
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        dismiss(animated: true, completion: nil)
        showAlert(message: "Something went wrong :(")
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
