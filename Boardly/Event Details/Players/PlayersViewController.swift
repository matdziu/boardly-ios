//
//  PlayersViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 01/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class PlayersViewController: ChildEventDetailsViewController, PlayersView {
    
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    @IBOutlet weak var contentTableView: UITableView!
    
    private let playersPresenter = PlayersPresenter(playersInteractor: PlayersInteractorImpl(playersService: PlayersServiceImpl()))
    private var initialize = true
    
    private var leaveEventSubject: PublishSubject<Bool>!
    private var fetchEventDetailsSubject: PublishSubject<Bool>!
    
    private var fetchedEvent = BoardlyEvent() {
        didSet {
            contentTableView.reloadData()
        }
    }
    private var acceptedPlayers: [Player] = [] {
        didSet {
            contentTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        playersPresenter.bind(playersView: self, eventId: eventId)
        fetchEventDetailsSubject.onNext(true)
    }
    
    override func initEmitters() {
        super.initEmitters()
        leaveEventSubject = PublishSubject()
        fetchEventDetailsSubject = PublishSubject()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        initialize = false
        playersPresenter.unbind()
        super.viewWillDisappear(animated)
    }
    
    func render(playersViewState: PlayersViewState) {
        showProgressView(show: playersViewState.eventProgress || playersViewState.playersProgress)
        fetchedEvent = playersViewState.event
        acceptedPlayers = playersViewState.acceptedPlayersList
    }
    
    private func showProgressView(show: Bool) {
        if show {
            progressView.startAnimating()
        } else {
            progressView.stopAnimating()
        }
    }
    
    func fetchEventDetailsTriggerEmitter() -> Observable<Bool> {
        return fetchEventDetailsSubject
    }
    
    func leaveEventEmitter() -> Observable<Bool> {
        return leaveEventSubject
    }
}

extension PlayersViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return acceptedPlayers.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        switch section {
        case 0:
            let eventViewCell = getEventViewCell(indexPath: indexPath)
            eventViewCell.bind(event: fetchedEvent)
            return eventViewCell
        case 1:
            let playerControlCell = getPlayerControlCell(indexPath: indexPath)
            playerControlCell.bind {
                
            }
            return playerControlCell
        case 2:
            let acceptedPlayerCell = getAcceptedPlayerCell(indexPath: indexPath)
            let player = acceptedPlayers[row]
            acceptedPlayerCell.bind(player: player) { selectedRating in
                self.emitRating(rateInput: RateInput(rating: selectedRating, playerId: player.id, eventId: player.eventId))
            }
            return acceptedPlayerCell
        default:
            return getEventViewCell(indexPath: indexPath)
        }
    }
    
    private func getEventViewCell(indexPath: IndexPath) -> BoardlyEventCell {
        return contentTableView.dequeueReusableCell(withIdentifier: EVENT_CELL_ID, for: indexPath) as! BoardlyEventCell
    }
    
    private func getPlayerControlCell(indexPath: IndexPath) -> PlayerControlCell {
        return contentTableView.dequeueReusableCell(withIdentifier: PLAYER_CONTROL_CELL, for: indexPath) as! PlayerControlCell
    }
    
    private func getAcceptedPlayerCell(indexPath: IndexPath) -> AcceptedPlayerCell {
        return contentTableView.dequeueReusableCell(withIdentifier: ACCEPTED_PLAYER_CELL, for: indexPath) as! AcceptedPlayerCell
    }
}
