//
//  DiscoverViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class DiscoverViewController: UIViewController, DiscoverView {
    
    private let discoverPresenter = DiscoverPresenter(discoverInteractor: DiscoverInteractorImpl(discoverService: DiscoverServiceImpl()))
    
    @IBOutlet weak var placesTableView: UITableView!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    @IBOutlet weak var noPlacesFoundLabel: UILabel!
    @IBOutlet weak var noLocationLabel: UILabel!
    
    private var placesList: [BoardlyPlace] = [] {
        didSet {
            placesTableView.reloadData()
        }
    }
    
    private var initialize = true
    
    private var fetchPlacesListTriggerSubject: PublishSubject<PlaceFilteredFetchData>!
    
    private var currentPlaceFilteredFetchData: PlaceFilteredFetchData? = nil
    private let decoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savePlaceFilteredFetchData()
        placesTableView.dataSource = self
        placesTableView.tableFooterView = UIView()
    }
    
    private func savePlaceFilteredFetchData() {
        if let savedFilterData = UserDefaults.standard.object(forKey: SAVED_FILTER) as? Data {
            if let savedFilter = try? decoder.decode(Filter.self, from: savedFilterData) {
                if savedFilter.userLocation != nil {
                    currentPlaceFilteredFetchData = PlaceFilteredFetchData(userLocation: savedFilter.userLocation!, radius: savedFilter.radius)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        discoverPresenter.bind(discoverView: self)
        if initialize && currentPlaceFilteredFetchData != nil {
            fetchPlacesListTriggerSubject.onNext(currentPlaceFilteredFetchData!)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        discoverPresenter.unbind()
        super.viewWillDisappear(animated)
    }
    
    private func initEmitters() {
        fetchPlacesListTriggerSubject = PublishSubject()
    }
    
    func fetchPlacesListTrigger() -> Observable<PlaceFilteredFetchData> {
        return fetchPlacesListTriggerSubject
    }
    
    func render(discoverViewState: DiscoverViewState) {
        if currentPlaceFilteredFetchData != nil {
            showProgressBar(show: discoverViewState.progress)
            showNoPlacesLabel(show: placesList.isEmpty)
            if !placesList.isEmpty {
                showNoPlacesLabel(show: false)
                showNoLocationLabel(show: false)
                placesList = discoverViewState.placesList
            }
        } else {
            showNoLocationLabel(show: true)
        }
    }
    
    private func showProgressBar(show: Bool) {
        if show {
            progressView.startAnimating()
        } else {
            progressView.stopAnimating()
        }
    }
    
    private func showNoLocationLabel(show: Bool) {
        if show {
            noLocationLabel.isHidden = false
            noPlacesFoundLabel.isHidden = true
        } else {
            noLocationLabel.isHidden = true
        }
    }
    
    private func showNoPlacesLabel(show: Bool) {
        if show {
            noPlacesFoundLabel.isHidden = false
            noLocationLabel.isHidden = true
        } else {
            noPlacesFoundLabel.isHidden = true
        }
    }
}

extension DiscoverViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let boardlyPlaceCell = tableView.dequeueReusableCell(withIdentifier: BOARDLY_PLACE_CELL_ID, for: indexPath) as! BoardlyPlaceCell
        let place = placesList[indexPath.row]
        boardlyPlaceCell.bind(place: place)
        return boardlyPlaceCell
    }
}
