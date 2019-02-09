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
import RxCocoa

enum Mode {
    case add
    case edit(event: BoardlyEvent)
}

class EventViewController: BaseNavViewController, EventView {
    
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
    private var mode: Mode = .add
    private var successHandler: () -> () = {}
    private var deleteEventHandler: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.doneAction = { [unowned self] in
            self.inputData.timestamp = $0.toMillis()
            self.dateLabel.text = $0.formatForDisplay()
        }
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
        gameLabel1.text = NSLocalizedString("No game picked", comment: "")
        gameLabel2.text = NSLocalizedString("No game picked", comment: "")
        gameLabel3.text = NSLocalizedString("No game picked", comment: "")
        placeLabel.text = NSLocalizedString("No place picked", comment: "")
        dateLabel.text = NSLocalizedString("No date picked", comment: "")
        contentScrollView.scrollToTop()
    }
    
    func prepare(mode: Mode, successHandler: @escaping () -> (), deleteEventHandler: @escaping () -> () = {}) {
        self.mode = mode
        self.successHandler = successHandler
        self.deleteEventHandler = deleteEventHandler
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
            gameNameLabel.text = NSLocalizedString("No game picked", comment: "")
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
        self.view.endEditing(true)
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
        guard let pickPlaceViewController = storyboard?.instantiateViewController(withIdentifier: PICK_PLACE_VIEW_CONTROLLER_ID) as? PickPlaceViewController else { return }
        pickPlaceViewController.finishAction = { searchPlaceResult in
            let latitude = searchPlaceResult.latitude
            let longitude = searchPlaceResult.longitude
            let locationName = searchPlaceResult.name
            self.inputData.placeLatitude = latitude
            self.inputData.placeLongitude = longitude
            self.inputData.placeName = locationName
            self.placeLabel.text = locationName
            self.emitPlacePickEvent = true
        }
        self.navigationController?.pushViewController(pickPlaceViewController, animated: true)
    }
    
    @IBAction func pickDateButtonClicked(_ sender: Any) {
        datePicker.show(show: true)
    }
    
    func addEventEmitter() -> Observable<EventInputData> {
        return addEventButton.rx.tap
            .do(onNext: { self.view.endEditing(true) })
            .map { [unowned self] in
            self.inputData.eventName = self.eventNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            self.inputData.description = self.descriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return self.inputData
        }
    }
    
    func editEventEmitter() -> Observable<EventInputData> {
        return saveChangesButton.rx.tap
            .do(onNext: { self.view.endEditing(true) })
            .map { [unowned self] in
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
            successHandler()
            reloadView()
        }
        if eventViewState.removed {
            deleteEventHandler()
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
    
    private func getPickGameViewController() -> PickGameViewController {
        return storyboard?.instantiateViewController(withIdentifier: PICK_GAME_VIEW_CONTROLLER_ID) as! PickGameViewController
    }
    
    private func launchDeleteEventDialog() {
        let alert = UIAlertController(title: NSLocalizedString("Delete the event", comment: ""), message: NSLocalizedString("Are you sure you want to delete this event?", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: { (action: UIAlertAction!) in
            self.deleteEventSubject.onNext(self.inputData.eventId)
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
}
