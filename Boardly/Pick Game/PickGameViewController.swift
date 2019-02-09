//
//  PickGameViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 09/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class PickGameViewController: BaseNavViewController, PickGameView {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var querySubject: PublishSubject<String>!
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchResults: [SearchResult] = [] {
        didSet {
            searchTableView.reloadData()
        }
    }
    
    var finishAction: (SearchResult) -> Void = { _ in }
    
    private let pickGamePresenter = PickGamePresenter(pickGameInteractor: PickGameInteractorImpl(gameService: GameServiceImpl()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchTableView.dataSource = self
        searchTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        pickGamePresenter.bind(pickGameView: self)
    }
    
    private func initEmitters() {
        querySubject = PublishSubject()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pickGamePresenter.unbind()
        super.viewWillDisappear(animated)
    }
    
    func render(pickGameViewState: PickGameViewState) {
        showProgressView(show: pickGameViewState.progress)
        showNoResultsPrompt(show: pickGameViewState.searchResults.isEmpty && !pickGameViewState.progress && pickGameViewState.error == nil)
        showContent(show: !pickGameViewState.searchResults.isEmpty && !pickGameViewState.progress && pickGameViewState.error == nil)
        showErrorPrompt(show: pickGameViewState.error != nil)
        searchResults = pickGameViewState.searchResults
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
        searchTableView.isHidden = !show
    }
    
    func queryEmitter() -> Observable<String> {
        return querySubject.debounce(0.3, scheduler: MainScheduler.instance).distinctUntilChanged()
    }
}

extension PickGameViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        querySubject.onNext(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension PickGameViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResultCell = tableView.dequeueReusableCell(withIdentifier: GAME_CELL_ID, for: indexPath) as! SearchResultCell
        let searchResult = searchResults[indexPath.row]
        searchResultCell.gameNameLabel.text = searchResult.name
        searchResultCell.yearPublishedLabel.text = searchResult.yearPublished
        return searchResultCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        finishAction(searchResults[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}
