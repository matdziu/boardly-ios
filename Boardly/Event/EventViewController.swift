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
import RxCocoa

enum Mode {
    case add
    case edit(event: BoardlyEvent)
}

class EventViewController: UIViewController, EventView {
    
    private var eventPresenter = EventPresenter(eventInteractor: EventInteractorImpl(gameService: GameServiceImpl(), eventService: EventServiceImpl()))
    private var inputData = EventInputData()
    @IBOutlet weak var gameLabel1: UILabel!
    @IBOutlet weak var gameLabel2: UILabel!
    @IBOutlet weak var gameLabel3: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var game1ImageView: UIImageView!
    @IBOutlet weak var game2ImageView: UIImageView!
    @IBOutlet weak var game3ImageView: UIImageView!
    @IBOutlet weak var datePicker: BoardlyDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var saveChangesButton: BoardlyButton!
    @IBOutlet weak var addEventButton: BoardlyButton!
    @IBOutlet weak var deleteEventButton: UIButton!
    @IBOutlet weak var eventNameTextField: BoardlyTextField!
    @IBOutlet weak var descriptionTextField: BoardlyTextField!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    private var gamePickEventSubject: PublishSubject<GamePickEvent>!
    private var placePickEventSubject: PublishSubject<Bool>!
    private var deleteEventSubject: PublishSubject<String>!
    
    private var emitGamePickEvent = false
    private var recentGamePickEvent = GamePickEvent()
    
    private var emitPlacePickEvent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.doneAction = { [unowned self] in
            self.inputData.timestamp = $0.toMillis()
            self.dateLabel.text = $0.formatForDisplay()
        }
    }
    
    func reloadView() {
        eventPresenter.unbind()
        inputData = EventInputData()
        eventPresenter = EventPresenter(eventInteractor: EventInteractorImpl(gameService: GameServiceImpl(), eventService: EventServiceImpl()))
        eventNameTextField.text = ""
        descriptionTextField.text = ""
        DispatchQueue.main.async {
            self.game1ImageView.image = UIImage(named: Image.boardGamePlaceholder.rawValue)
            self.game2ImageView.image = UIImage(named: Image.boardGamePlaceholder.rawValue)
            self.game3ImageView.image = UIImage(named: Image.boardGamePlaceholder.rawValue)
        }
        gameLabel1.text = "No game picked"
        gameLabel2.text = "No game picked"
        gameLabel3.text = "No game picked"
        placeLabel.text = "No place picked"
        dateLabel.text = "No date picked"
        contentScrollView.scrollToTop()
    }
    
    func prepare(mode: Mode) {
        switch mode {
        case .add:
            saveChangesButton.isHidden = true
            deleteEventButton.isHidden = true
            addEventButton.isHidden = false
            clearButton.isHidden = false
        case .edit(let event):
            saveChangesButton.isHidden = false
            deleteEventButton.isHidden = false
            addEventButton.isHidden = true
            clearButton.isHidden = true
            renderEventData(event: event)
            updateInputData(event: event)
        }
    }
    
    private func renderEventData(event: BoardlyEvent) {
        eventNameTextField.text = event.eventName
        descriptionTextField.text = event.description
        placeLabel.text = event.placeName
        if event.timestamp > 0 {
            dateLabel.text = Date(timeIntervalSince1970: TimeInterval(event.timestamp / 1000)).formatForDisplay()
        }
        loadGameSection(gameImageView: game1ImageView, gameImageUrl: event.gameImageUrl, gameNameLabel: gameLabel1, gameName: event.gameName)
        loadGameSection(gameImageView: game2ImageView, gameImageUrl: event.gameImageUrl2, gameNameLabel: gameLabel2, gameName: event.gameName2)
        loadGameSection(gameImageView: game3ImageView, gameImageUrl: event.gameImageUrl3, gameNameLabel: gameLabel3, gameName: event.gameName3)
    }
    
    private func loadGameSection(gameImageView: UIImageView, gameImageUrl: String,
                                 gameNameLabel: UILabel, gameName: String) {
        gameImageView.downloaded(from: gameImageUrl, placeHolder: UIImage(named: Image.boardGamePlaceholder.rawValue))
        if !gameName.isEmpty {
            gameNameLabel.text = gameName
        } else {
            gameNameLabel.text = "No game picked"
        }
    }
    
    private func updateInputData(event: BoardlyEvent) {
        inputData.eventId = event.eventId
        inputData.gameName = event.gameName
        inputData.gameId = event.gameId
        inputData.gameName2 = event.gameName2
        inputData.gameId2 = event.gameId2
        inputData.gameName3 = event.gameName3
        inputData.gameId3 = event.gameId3
        inputData.gameImageUrl = event.gameImageUrl
        inputData.gameImageUrl2 = event.gameImageUrl2
        inputData.gameImageUrl3 = event.gameImageUrl3
        inputData.placeName = event.placeName
        inputData.placeLatitude = event.placeLatitude
        inputData.placeLongitude = event.placeLongitude
        inputData.timestamp = event.timestamp
        inputData.adminId = event.adminId
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        eventPresenter.bind(eventView: self)
        initView()
    }
    
    private func initView() {
        if (emitGamePickEvent) {
            gamePickEventSubject.onNext(recentGamePickEvent)
            emitGamePickEvent = false
        }
        if (emitPlacePickEvent) {
            placePickEventSubject.onNext(true)
            emitPlacePickEvent = false
        }
    }
    
    private func initEmitters() {
        gamePickEventSubject = PublishSubject()
        placePickEventSubject = PublishSubject()
        deleteEventSubject = PublishSubject()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        eventPresenter.unbind()
        super.viewWillDisappear(animated)
    }
    
    @IBAction func clearButtonClicked(_ sender: Any) {
        reloadView()
        eventPresenter.bind(eventView: self)
    }
    
    @IBAction func pickGame1ButtonClicked(_ sender: Any) {
        let pickGameViewController = getPickGameViewController()
        pickGameViewController.finishAction = {
            self.gameLabel1.text = $0.name
            self.inputData.gameId = self.formatId(id: $0.id, type: $0.type)
            self.inputData.gameName = $0.name
            self.recentGamePickEvent = GamePickEvent(gameId: self.formatId(id: $0.id, type: $0.type), type: .first)
            self.emitGamePickEvent = true
        }
        self.navigationController?.pushViewController(pickGameViewController, animated: true)
    }
    
    @IBAction func pickGame2ButtonClicked(_ sender: Any) {
        let pickGameViewController = getPickGameViewController()
        pickGameViewController.finishAction = {
            self.gameLabel2.text = $0.name
            self.inputData.gameId2 = self.formatId(id: $0.id, type: $0.type)
            self.inputData.gameName2 = $0.name
            self.recentGamePickEvent = GamePickEvent(gameId: self.formatId(id: $0.id, type: $0.type), type: .second)
            self.emitGamePickEvent = true
        }
        self.navigationController?.pushViewController(pickGameViewController, animated: true)
    }
    
    @IBAction func pickGame3ButtonClicked(_ sender: Any) {
        let pickGameViewController = getPickGameViewController()
        pickGameViewController.finishAction = {
            self.gameLabel3.text = $0.name
            self.inputData.gameId3 = self.formatId(id: $0.id, type: $0.type)
            self.inputData.gameName3 = $0.name
            self.recentGamePickEvent = GamePickEvent(gameId: self.formatId(id: $0.id, type: $0.type), type: .third)
            self.emitGamePickEvent = true
        }
        self.navigationController?.pushViewController(pickGameViewController, animated: true)
    }
    
    @IBAction func deleteEventButtonClicked(_ sender: Any) {
        launchDeleteEventDialog()
    }
    
    private func formatId(id: String, type: String) -> String {
        if (type == RPG_TYPE) {
            return "\(id)\(RPG_TYPE)"
        } else {
            return id
        }
    }
    
    @IBAction func pickPlaceButtonClicked(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func pickDateButtonClicked(_ sender: Any) {
        datePicker.show(show: true)
    }
    
    func addEventEmitter() -> Observable<EventInputData> {
        return addEventButton.rx.tap.map { [unowned self] in
            self.inputData.eventName = self.eventNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            self.inputData.description = self.descriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return self.inputData
        }
    }
    
    func editEventEmitter() -> Observable<EventInputData> {
        return saveChangesButton.rx.tap.map { [unowned self] in
            self.inputData.eventName = self.eventNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            self.inputData.description = self.descriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return self.inputData
        }
    }
    
    func deleteEventEmitter() -> Observable<String> {
        return deleteEventSubject
    }
    
    func gamePickEventEmitter() -> Observable<GamePickEvent> {
        return gamePickEventSubject
    }
    
    func placePickEventEmitter() -> Observable<Bool> {
        return placePickEventSubject
    }
    
    func render(eventViewState: EventViewState) {
        eventNameTextField.showError(show: !eventViewState.eventNameValid)
        showProgress(show: eventViewState.progress)
        showPickedGameError(show: !eventViewState.selectedGameValid)
        showPickedPlaceError(show: !eventViewState.selectedPlaceValid)
        loadAndSaveGameImage(game: eventViewState.selectedGame,
                             boardGameImageView: game1ImageView,
                             inputDataSetter: { inputData.gameImageUrl = $0 })
        loadAndSaveGameImage(game: eventViewState.selectedGame2,
                             boardGameImageView: game2ImageView,
                             inputDataSetter: { inputData.gameImageUrl2 = $0 })
        loadAndSaveGameImage(game: eventViewState.selectedGame3,
                             boardGameImageView: game3ImageView,
                             inputDataSetter: { inputData.gameImageUrl3 = $0 })
        if eventViewState.success {
            showAlert(message: "Everything went well!")
            self.tabBarController?.selectedIndex = 0
            reloadView()
        }
        if eventViewState.removed {
            showAlert(message: "Everything went well!")
        }
    }
    
    private func showProgress(show: Bool) {
        if show {
            progressView.startAnimating()
        } else {
            progressView.stopAnimating()
        }
    }
    
    private func showPickedGameError(show: Bool) {
        if show {
            gameLabel1.textColor = UIColor(named: Color.errorRed.rawValue)
        } else {
            gameLabel1.textColor = UIColor(named: Color.grey.rawValue)
        }
    }
    
    private func showPickedPlaceError(show: Bool) {
        if show {
            placeLabel.textColor = UIColor(named: Color.errorRed.rawValue)
        } else {
            placeLabel.textColor = UIColor(named: Color.grey.rawValue)
        }
    }
    
    private func loadAndSaveGameImage(game: Game, boardGameImageView: UIImageView, inputDataSetter: (String) -> Void) {
        if game.id != "-1" {
            inputDataSetter(game.image)
            boardGameImageView.downloaded(from: game.image, placeHolder: UIImage(named: Image.boardGamePlaceholder.rawValue))
        }
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
    
    private func getPickGameViewController() -> PickGameViewController {
        return storyboard?.instantiateViewController(withIdentifier: PICK_GAME_VIEW_CONTROLLER_ID) as! PickGameViewController
    }
    
    private func launchDeleteEventDialog() {
        let alert = UIAlertController(title: "Delete the event", message: "Are you sure you want to delete this event?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
            self.deleteEventSubject.onNext(self.inputData.eventId)
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
}
