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

class NotifyViewController: UIViewController, NotifyView {
    
    private var gameIdSubject: PublishSubject<String>!
    private var notifySettingsFetchSubject: PublishSubject<Bool>!
    private var placePickEventSubject: PublishSubject<Bool>!
    @IBOutlet weak var eventDistanceLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var deleteNotificationsButton: UIButton!
    @IBOutlet weak var applyButton: BoardlyButton!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    @IBOutlet weak var distanceSlider: UISlider!
    
    private let distanceLabelDefaultText = NSLocalizedString("Maximum event distance:", comment: "")
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
        if resetSettings {
            gameIdSubject.onNext(currentSettings.gameId)
        }
        
        resetSettings = true
        
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
        guard let pickPlaceViewController = storyboard?.instantiateViewController(withIdentifier: PICK_PLACE_VIEW_CONTROLLER_ID) as? PickPlaceViewController else { return }
        pickPlaceViewController.finishAction = { searchPlaceResult in
            self.newSettings.userLatitude = searchPlaceResult.latitude
            self.newSettings.userLongitude = searchPlaceResult.longitude
            let locationName = searchPlaceResult.name
            self.newSettings.locationName = locationName
            self.placeNameLabel.text = locationName
            self.emitPlacePickEvent = true
        }
        self.navigationController?.pushViewController(pickPlaceViewController, animated: true)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let value = sender.value
        eventDistanceLabel.text = "\(distanceLabelDefaultText) \(Int(value))km"
        newSettings.radius = Double(value)
    }
    
    func render(notifyViewState: NotifyViewState) {
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
        showAlert(message: NSLocalizedString("Saved successfully!", comment: ""))
        self.tabBarController?.selectedIndex = 0
    }
    
    private func reloadView() {
        notifyPresenter.unbind()
        newSettings = currentSettings
        notifyPresenter = NotifyPresenter(notifyInteractor: NotifyInteractorImpl(gameService: GameServiceImpl(), notifyService: NotifyServiceImpl()), initialViewState: NotifyViewState(notifySettings: currentSettings))
        setNotifySettings(notifySettings: currentSettings)
        notifyPresenter.bind(notifyView: self)
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
        setLocationSetting(locationName: notifySettings.locationName)
    }
    
    private func setDistanceSetting(radius: Int) {
        distanceSlider.value = Float(radius)
        eventDistanceLabel.text = "\(distanceLabelDefaultText) \(radius)km"
    }
    
    private func setLocationSetting(locationName: String) {
        if !locationName.isEmpty {
            placeNameLabel.text = locationName
        } else {
            placeNameLabel.text = NSLocalizedString("No place picked", comment: "")
        }
    }
}
