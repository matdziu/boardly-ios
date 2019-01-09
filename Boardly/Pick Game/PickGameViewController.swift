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
    
    private var querySubject: PublishSubject<String>!
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let pickGamePresenter = PickGamePresenter(pickGameInteractor: PickGameInteractorImpl(gameService: GameServiceImpl()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchController()
    }
    
    private func setSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for games"
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
        
    }
    
    func queryEmitter() -> Observable<String> {
        return querySubject
    }
}

extension PickGameViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
