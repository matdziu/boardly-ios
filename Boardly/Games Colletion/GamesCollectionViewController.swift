//
//  GamesCollectionViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class GamesCollectionViewController: BaseNavViewController, GamesCollectionView {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noGamesLabel: UILabel!
    @IBOutlet weak var gamesTableView: UITableView!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    private var querySubject: PublishSubject<String>!
    private var initialFetchSubject: PublishSubject<Bool>!
    private var initialize = true
    
    private var gamesList: [CollectionGame] = [] {
        didSet {
            gamesTableView.reloadData()
        }
    }
    
    private let gamesCollectionPresenter = GamesCollectionPresenter(gamesCollectionInteractor: GamesCollectionInteractorImpl(gamesCollectionService: GamesCollectionServiceImpl()))
    
    private var collectionId: String = ""
    
    func prepare(collectionId: String) {
        self.collectionId = collectionId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        gamesTableView.dataSource = self
        gamesTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        gamesCollectionPresenter.bind(gamesCollectionView: self, collectionId: collectionId)
        if initialize {
            initialFetchSubject.onNext(true)
        }
    }
    
    private func initEmitters() {
        querySubject = PublishSubject()
        initialFetchSubject = PublishSubject()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        initialize = false
        gamesCollectionPresenter.unbind()
        super.viewWillDisappear(animated)
    }
    
    func render(gamesCollectionViewState: GamesCollectionViewState) {
        showProgressView(show: gamesCollectionViewState.progress)
        showNoGamesText(show: gamesCollectionViewState.games.isEmpty && !gamesCollectionViewState.progress)
        gamesList = gamesCollectionViewState.games
    }
    
    private func showNoGamesText(show: Bool) {
        noGamesLabel.isHidden = !show
    }
    
    private func showProgressView(show: Bool) {
        if show {
            progressView.startAnimating()
        } else {
            progressView.stopAnimating()
        }
    }
    
    func queryEmitter() -> Observable<String> {
        return querySubject
    }
    
    func initialFetchTriggerEmitter() -> Observable<Bool> {
        return initialFetchSubject
    }
}

extension GamesCollectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        querySubject.onNext(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension GamesCollectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let collectionGameCell = tableView.dequeueReusableCell(withIdentifier: COLLECTION_GAME_CELL_ID, for: indexPath) as! CollectionGameCell
        let collectionGame = gamesList[indexPath.row]
        collectionGameCell.selectionStyle = UITableViewCell.SelectionStyle.none
        collectionGameCell.bind(game: collectionGame)
        return collectionGameCell
    }
}
