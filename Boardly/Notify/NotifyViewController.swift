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
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var boardGameImageView: UIImageView!
    @IBOutlet weak var deleteNotificationsButton: UIButton!
    @IBOutlet weak var applyButton: BoardlyButton!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    @IBOutlet weak var distanceSlider: UISlider!
    
    private let distanceLabelDefaultText = "Maximum event distance:"
    private var initializeSettings = true
    private var resetSettings = true
    
    private var newSettings = NotifySettings()
    private var currentSettings = NotifySettings()
    
    private var emitPlacePickEvent = false
    private var fetchGameDetails = false
    
    private var notifyPresenter = NotifyPresenter(notifyInteractor: NotifyInteractorImpl(gameService: GameServiceImpl(), notifyService: NotifyServiceImpl()))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        notifyPresenter.bind(notifyView: self)
        initView()
    }
    
    private func initEmitters() {
        gameIdSubject = PublishSubject()
        notifySettingsFetchSubject = PublishSubject()
        placePickEventSubject = PublishSubject()
    }
    
    private func initView() {
        resetSettings = true
        gameIdSubject.onNext(currentSettings.gameId)
        
        if initializeSettings {
            notifySettingsFetchSubject.onNext(initializeSettings)
            initializeSettings = false
        }
        
        if emitPlacePickEvent {
            placePickEventSubject.onNext(true)
            emitPlacePickEvent = false
        }
        
        if fetchGameDetails {
            gameIdSubject.onNext(newSettings.gameId)
            fetchGameDetails = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deinitView()
        notifyPresenter.unbind()
        super.viewWillDisappear(animated)
    }
    
    private func deinitView() {
        if resetSettings {
            reloadView()
        }
    }
    
    func gameIdEmitter() -> Observable<String> {
        return gameIdSubject
    }
    
    func notifySettingsEmitter() -> Observable<NotifySettings> {
        return applyButton.rx.tap.map { _ in return self.newSettings }
    }
    
    func notifySettingsFetchEmitter() -> Observable<Bool> {
        return notifySettingsFetchSubject
    }
    
    func stopNotificationsButtonClickEmitter() -> Observable<Bool> {
        return deleteNotificationsButton.rx.tap.map { _ in return true }
    }
    
    func placePickEventEmitter() -> Observable<Bool> {
        return placePickEventSubject
    }
    
    @IBAction func pickGameButtonClicked(_ sender: Any) {
        guard let pickGameViewController = storyboard?.instantiateViewController(withIdentifier: PICK_GAME_VIEW_CONTROLLER_ID) as? PickGameViewController else { return }
        pickGameViewController.finishAction = { self.handlePickGameResult(pickedGame: $0) }
        resetSettings = false
        self.navigationController?.pushViewController(pickGameViewController, animated: true)
    }
    
    private func handlePickGameResult(pickedGame: SearchResult) {
        gameNameLabel.text = pickedGame.name
        newSettings.gameName = pickedGame.name
        newSettings.gameId = formatId(id: pickedGame.id, type: pickedGame.type)
        fetchGameDetails = true
    }
    
    private func formatId(id: String, type: String) -> String {
        if (type == RPG_TYPE) {
            return "\(id)\(RPG_TYPE)"
        } else {
            return id
        }
    }
    
    @IBAction func pickPlaceButtonClicked(_ sender: Any) {
        resetSettings = false
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func deleteGameButtonClicked(_ sender: Any) {
        boardGameImageView.cancel()
        showPlaceholderBoardGameImage()
        gameNameLabel.text = "No game picked"
        newSettings.gameId = ""
        newSettings.gameName = ""
        gameIdSubject.onNext("")
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let value = sender.value
        eventDistanceLabel.text = "\(distanceLabelDefaultText) \(Int(value))km"
        newSettings.radius = Double(value)
    }
    
    func render(notifyViewState: NotifyViewState) {
        boardGameImageView.downloaded(from: notifyViewState.gameImageUrl)
        showProgressBar(show: notifyViewState.progress)
        showPlacePickedError(show: !notifyViewState.selectedPlaceValid)
        if notifyViewState.successSaved {
            currentSettings = newSettings
            finish()
        }
        if notifyViewState.successDeleted {
            currentSettings = NotifySettings()
            newSettings = NotifySettings()
            finish()
        }
        let notifySettings = notifyViewState.notifySettings
        if currentSettings != notifySettings {
            currentSettings = notifySettings
            newSettings = notifySettings
            setNotifySettings(notifySettings: notifySettings)
            gameIdSubject.onNext(notifySettings.gameId)
        }
    }
    
    private func finish() {
        reloadView()
        showAlert(message: "Saved successfully!")
        self.tabBarController?.selectedIndex = 0
    }
    
    private func reloadView() {
        notifyPresenter.unbind()
        notifyPresenter = NotifyPresenter(notifyInteractor: NotifyInteractorImpl(gameService: GameServiceImpl(), notifyService: NotifyServiceImpl()), initialViewState: NotifyViewState(notifySettings: currentSettings))
        setNotifySettings(notifySettings: currentSettings)
        notifyPresenter.bind(notifyView: self)
    }
    
    private func showPlaceholderBoardGameImage() {
        boardGameImageView.cancel()
        DispatchQueue.main.async {
            self.boardGameImageView.image = UIImage(named: Image.boardGamePlaceholder.rawValue)
        }
    }
    
    private func showProgressBar(show: Bool) {
        if show {
            progressView.startAnimating()
        } else {
            progressView.stopAnimating()
        }
    }
    
    private func showPlacePickedError(show: Bool) {
        if show {
            placeNameLabel.textColor = UIColor(named: Color.errorRed.rawValue)
        } else {
            placeNameLabel.textColor = UIColor(named: Color.grey.rawValue)
        }
    }
    
    private func setNotifySettings(notifySettings: NotifySettings) {
        setDistanceSetting(radius: Int(notifySettings.radius))
        setGameSetting(gameName: notifySettings.gameName)
        setLocationSetting(locationName: notifySettings.locationName)
    }
    
    private func setDistanceSetting(radius: Int) {
        distanceSlider.value = Float(radius)
        eventDistanceLabel.text = "\(distanceLabelDefaultText) \(radius)km"
    }
    
    private func setGameSetting(gameName: String) {
        if !gameName.isEmpty {
            gameNameLabel.text = gameName
        } else {
            gameNameLabel.text = "No game picked"
            showPlaceholderBoardGameImage()
        }
    }
    
    private func setLocationSetting(locationName: String) {
        if !locationName.isEmpty {
            placeNameLabel.text = locationName
        } else {
            placeNameLabel.text = "No place picked"
        }
    }
}

extension NotifyViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        newSettings.userLatitude = place.coordinate.latitude
        newSettings.userLongitude = place.coordinate.longitude
        let locationName = place.formattedAddress ?? place.name
        newSettings.locationName = locationName
        placeNameLabel.text = locationName
        emitPlacePickEvent = true
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
