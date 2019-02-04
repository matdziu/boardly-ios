//
//  HomeViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 19/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import CoreLocation

class HomeViewController: BaseJoinEventViewController, HomeView {
    
    @IBOutlet weak var noEventsFoundLabel: UILabel!
    @IBOutlet weak var turnOnLocationLabel: UILabel!
    @IBOutlet weak var settingLocationLabel: UILabel!
    @IBOutlet weak var lookingForEventsLabel: UILabel!
    @IBOutlet weak var eventsTableView: UITableView!
    private let locationManager = CLLocationManager()
    
    private let homePresenter = HomePresenter(homeInteractor: HomeInteractorImpl(homeService: HomeServiceImpl()))
    
    private var filteredFetchTriggerSubject: PublishSubject<FilteredFetchData>!
    private var locationProcessingSubject: PublishSubject<Bool>!
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private var selectedFilter = Filter()
    private var initialize = true
    var fromFilter = false
    
    private var events: [BoardlyEvent] = [] {
        didSet {
            eventsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        eventsTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        getFilterFromDefaults()
        homePresenter.bind(homeView: self)
        if fromFilter {
            fromFilter = false
            filteredFetchTriggerSubject.onNext(FilteredFetchData(filter: selectedFilter, initialize: true))
        } else if selectedFilter.isCurrentLocation {
            if initialize {
                locationManager.delegate = self
            } else {
                locationManager.requestLocation()
            }
        } else {
            filteredFetchTriggerSubject.onNext(FilteredFetchData(filter: selectedFilter, initialize: initialize))
        }
    }
    
    private func initEmitters() {
        filteredFetchTriggerSubject = PublishSubject()
        locationProcessingSubject = PublishSubject()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        homePresenter.unbind()
        initialize = false
        super.viewWillDisappear(animated)
    }
    
    func filteredFetchTriggerEmitter() -> Observable<FilteredFetchData> {
        return filteredFetchTriggerSubject
    }
    
    func locationProcessingEmitter() -> Observable<Bool> {
        return locationProcessingSubject
    }
    
    func render(homeViewState: HomeViewState) {
        eventsTableView.isHidden = homeViewState.eventList.isEmpty
        noEventsFoundLabel.isHidden = true
        turnOnLocationLabel.isHidden = isLocationPermissionGranted() || homeViewState.progress
        lookingForEventsLabel.isHidden = !homeViewState.progress
        settingLocationLabel.isHidden = !homeViewState.locationProcessing
        events = homeViewState.eventList
        
        if !homeViewState.progress && !homeViewState.locationProcessing && !homeViewState.eventList.isEmpty {
            turnOnLocationLabel.isHidden = true
        } else if homeViewState.eventList.isEmpty && !homeViewState.progress && !homeViewState.locationProcessing && isLocationPermissionGranted() {
            noEventsFoundLabel.isHidden = false
        }
    }
    
    private func enterEvent(event: BoardlyEvent) {
        guard let eventDetailsViewController = storyboard?.instantiateViewController(withIdentifier: EVENT_DETAILS_VIEW_CONTROLLER_ID) as? EventDetailsViewController else { return }
        eventDetailsViewController.prepare(isAdmin: event.type == .CREATED, eventId: event.eventId)
        self.navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
    
    private func getFilterFromDefaults() {
        if let savedFilterData = UserDefaults.standard.object(forKey: SAVED_FILTER) as? Data {
            if let savedFilter = try? decoder.decode(Filter.self, from: savedFilterData) {
                selectedFilter = savedFilter
            }
        }
    }
    
    private func saveFilterToDefaults(filter: Filter) {
        if let savedFilterData = try? encoder.encode(filter) {
            UserDefaults.standard.set(savedFilterData, forKey: SAVED_FILTER)
        }
    }
    
    private func isLocationPermissionGranted() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            }
        } else {
            return false
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let boardlyEventCell = eventsTableView.dequeueReusableCell(withIdentifier: EVENT_CELL_ID, for: indexPath) as! BoardlyEventCell
        let event = events[indexPath.row]
        boardlyEventCell.bind(event: event, cellClickAction: { self.cellClickAction(event: event) })
        return boardlyEventCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        cellClickAction(event: event)
    }
    
    private func cellClickAction(event: BoardlyEvent) {
        switch event.type {
        case .CREATED, .ACCEPTED:
            enterEvent(event: event)
        case .PENDING:
            return
        case .DEFAULT:
            joinEvent(eventId: event.eventId)
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let rawLocation = locations.last else { return }
        selectedFilter.userLocation = UserLocation(latitude: rawLocation.coordinate.latitude, longitude: rawLocation.coordinate.longitude)
        selectedFilter.locationName = "Current location"
        selectedFilter.isCurrentLocation = true
        saveFilterToDefaults(filter: selectedFilter)
        filteredFetchTriggerSubject.onNext(FilteredFetchData(filter: selectedFilter, initialize: initialize))
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            turnOnLocationLabel.isHidden = true
            eventsTableView.isHidden = false
            noEventsFoundLabel.isHidden = !events.isEmpty
            if selectedFilter.isCurrentLocation {
                locationManager.requestLocation()
                locationProcessingSubject.onNext(initialize)
            }
        } else {
            turnOnLocationLabel.isHidden = false
            noEventsFoundLabel.isHidden = true
            eventsTableView.isHidden = !events.isEmpty
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        turnOnLocationLabel.isHidden = false
        noEventsFoundLabel.isHidden = !events.isEmpty
        eventsTableView.isHidden = true
    }
}
