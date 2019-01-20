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

class HomeViewController: UIViewController, HomeView {
    
    @IBOutlet weak var noEventsFoundLabel: UILabel!
    @IBOutlet weak var turnOnLocationLabel: UILabel!
    @IBOutlet weak var settingLocationLabel: UILabel!
    @IBOutlet weak var lookingForEventsLabel: UILabel!
    @IBOutlet weak var eventsTableView: UITableView!
    
    private let homePresenter = HomePresenter(homeInteractor: HomeInteractorImpl(homeService: HomeServiceImpl()))
    
    private var filteredFetchTriggerSubject: PublishSubject<FilteredFetchData>!
    private var locationProcessingSubject: PublishSubject<Bool>!
    
    private let decoder = JSONDecoder()
    private var selectedFilter = Filter()
    private var initialize = true
    
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
        getFilterFromDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        homePresenter.bind(homeView: self)
        if selectedFilter.isCurrentLocation {
            
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
    
    func joinEventEmitter() -> Observable<JoinEventData> {
        // move to BaseJoinEventViewController
        return Observable.empty()
    }
    
    func render(homeViewState: HomeViewState) {
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
    
    private func showJoinEventViewController() {
        guard let joinEventViewController = storyboard?.instantiateViewController(withIdentifier: JOIN_EVENT_VIEW_CONTROLLER_ID)
            as? JoinEventViewController else { return }
        joinEventViewController.providesPresentationContextTransitionStyle = true
        joinEventViewController.definesPresentationContext = true
        joinEventViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(joinEventViewController, animated: true, completion: nil)
    }
    
    private func getFilterFromDefaults() {
        if let savedFilterData = UserDefaults.standard.object(forKey: SAVED_FILTER) as? Data {
            if let savedFilter = try? decoder.decode(Filter.self, from: savedFilterData) {
                selectedFilter = savedFilter
            }
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
        boardlyEventCell.bind(event: event)
        return boardlyEventCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
