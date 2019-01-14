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
    @IBOutlet weak var game1ImageView: UIImageView!
    @IBOutlet weak var game2ImageView: UIImageView!
    @IBOutlet weak var game3ImageView: UIImageView!
    @IBOutlet weak var datePicker: BoardlyDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    private let dateFormatter = DateFormatter()
    
    private var gamePickEventSubject: PublishSubject<GamePickEvent>!
    private var placePickEventSubject: PublishSubject<Bool>!
    private var deleteEventSubject: PublishSubject<String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "EEE, d MMM yyyy, HH:mm"
        datePicker.doneAction = { [unowned self] in
            self.inputData.timestamp = $0.toMillis()
            self.dateLabel.text = self.dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval($0.toMillis() / 1000)))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        eventPresenter.bind(eventView: self)
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
    
    @IBAction func pickGame1ButtonClicked(_ sender: Any) {
        let pickGameViewController = getPickGameViewController()
        pickGameViewController.finishAction = {
            self.gameLabel1.text = $0.name
            self.inputData.gameId = self.formatId(id: $0.id, type: $0.type)
            self.inputData.gameName = $0.name
        }
        self.navigationController?.pushViewController(pickGameViewController, animated: true)
    }
    
    @IBAction func pickGame2ButtonClicked(_ sender: Any) {
        let pickGameViewController = getPickGameViewController()
        pickGameViewController.finishAction = {
            self.gameLabel2.text = $0.name
            self.inputData.gameId2 = self.formatId(id: $0.id, type: $0.type)
            self.inputData.gameName2 = $0.name
        }
        self.navigationController?.pushViewController(pickGameViewController, animated: true)
    }
    
    @IBAction func pickGame3ButtonClicked(_ sender: Any) {
        let pickGameViewController = getPickGameViewController()
        pickGameViewController.finishAction = {
            self.gameLabel3.text = $0.name
            self.inputData.gameId3 = self.formatId(id: $0.id, type: $0.type)
            self.inputData.gameName3 = $0.name
        }
        self.navigationController?.pushViewController(pickGameViewController, animated: true)
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
        return Observable.empty()
    }
    
    func editEventEmitter() -> Observable<EventInputData> {
        return Observable.empty()
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
    
    private func getPickGameViewController() -> PickGameViewController {
        return storyboard?.instantiateViewController(withIdentifier: PICK_GAME_VIEW_CONTROLLER_ID) as! PickGameViewController
    }
}
