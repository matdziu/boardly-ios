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

class HomeViewController: UIViewController, HomeView {
    
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    @IBOutlet weak var noEventsFoundLabel: UILabel!
    @IBOutlet weak var turnOnLocationLabel: UILabel!
    @IBOutlet weak var settingLocationLabel: UILabel!
    @IBOutlet weak var lookingForEventsLabel: UILabel!
    
    private let homePresenter = HomePresenter(homeInteractor: HomeInteractorImpl(homeService: HomeServiceImpl()))
    
    private var filteredFetchTriggerSubject: PublishSubject<FilteredFetchData>!
    private var locationProcessingSubject: PublishSubject<Bool>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsCollectionView.dataSource = self
        eventsCollectionView.delegate = self
    }
    
    private var events: [BoardlyEvent] = [] {
        didSet {
            eventsCollectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        homePresenter.bind(homeView: self)
    }
    
    private func initEmitters() {
        filteredFetchTriggerSubject = PublishSubject()
        locationProcessingSubject = PublishSubject()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        homePresenter.unbind()
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
        showJoinEventViewController()
    }
    
    private func showJoinEventViewController() {
        guard let joinEventViewController = storyboard?.instantiateViewController(withIdentifier: JOIN_EVENT_VIEW_CONTROLLER_ID)
            as? JoinEventViewController else { return }
        present(joinEventViewController, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let boardlyEventCell = collectionView.dequeueReusableCell(withReuseIdentifier: EVENT_CELL_ID, for: indexPath) as! BoardlyEventCell
        let event = events[indexPath.row]
        return boardlyEventCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 334)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
