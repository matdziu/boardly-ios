//
//  PickPlaceViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 08/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class PickPlaceViewController: BaseNavViewController, PickPlaceView {
    
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var resultsTableView: UITableView!
    
    private let pickPlacePresenter = PickPlacePresenter(pickPlaceInteractor: PickPlaceInteractorImpl(pickPlaceService: PickPlaceServiceImpl()))
    private var querySubject: PublishSubject<String>!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchResults: [PlaceSearchResult] = [] {
        didSet {
            resultsTableView.reloadData()
        }
    }
    
    var finishAction: (PlaceSearchResult) -> Void = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        pickPlacePresenter.bind(pickPlaceView: self)
    }
    
    private func initEmitters() {
        querySubject = PublishSubject()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pickPlacePresenter.unbind()
        super.viewWillDisappear(animated)
    }
    
    func render(pickPlaceViewState: PickPlaceViewState) {
        showProgressView(show: pickPlaceViewState.progress)
        showNoResultsPrompt(show: pickPlaceViewState.searchResults.isEmpty && !pickPlaceViewState.progress && pickPlaceViewState.error == nil)
        showContent(show: !pickPlaceViewState.searchResults.isEmpty && !pickPlaceViewState.progress && pickPlaceViewState.error == nil)
        showErrorPrompt(show: pickPlaceViewState.error != nil)
        searchResults = pickPlaceViewState.searchResults
    }
    
    private func showProgressView(show: Bool) {
        if show {
            progressView.startAnimating()
        } else {
            progressView.stopAnimating()
        }
    }
    
    private func showNoResultsPrompt(show: Bool) {
        noResultsLabel.isHidden = !show
    }
    
    private func showErrorPrompt(show: Bool) {
        errorLabel.isHidden = !show
    }
    
    private func showContent(show: Bool) {
        resultsTableView.isHidden = !show
    }
    
    func queryEmitter() -> Observable<String> {
        return querySubject.debounce(0.3, scheduler: MainScheduler.instance).distinctUntilChanged()
    }
}

extension PickPlaceViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        querySubject.onNext(searchText)
    }
}

extension PickPlaceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResultCell = tableView.dequeueReusableCell(withIdentifier: PLACE_CELL_ID, for: indexPath) as! PlaceSearchResultCell
        let searchResult = searchResults[indexPath.row]
        searchResultCell.placeNameLabel.text = searchResult.name
        return searchResultCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        finishAction(searchResults[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}
