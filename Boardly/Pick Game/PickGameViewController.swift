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
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var querySubject: PublishSubject<String>!
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchResults: [SearchResult] = [] {
        didSet {
            searchCollectionView.reloadData()
        }
    }
    
    private let pickGamePresenter = PickGamePresenter(pickGameInteractor: PickGameInteractorImpl(gameService: GameServiceImpl()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
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
        searchCollectionView.isHidden = !show
    }
    
    func queryEmitter() -> Observable<String> {
        return querySubject.debounce(0.3, scheduler: MainScheduler.instance).distinctUntilChanged()
    }
}

extension PickGameViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        querySubject.onNext(searchText)
    }
}

extension PickGameViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchResultCell = collectionView.dequeueReusableCell(withReuseIdentifier: GAME_CELL_ID, for: indexPath) as! SearchResultCell
        let searchResult = searchResults[indexPath.row]
        searchResultCell.gameNameLabel.text = searchResult.name
        searchResultCell.yearPublishedLabel.text = searchResult.yearPublished
        return searchResultCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 84)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let filterViewController = self.navigationController?.viewControllers[1] as? FilterViewController else { return }
        let pickedGame = searchResults[indexPath.row]
        filterViewController.handlePickGameResult(pickedGame: pickedGame)
        self.navigationController?.popViewController(animated: true)
    }
}
