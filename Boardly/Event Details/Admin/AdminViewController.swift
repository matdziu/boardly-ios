//
//  AdminViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 01/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AdminViewController: ChildEventDetailsViewController, AdminView {
    
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    @IBOutlet weak var contentTableView: UITableView!
    
    private var acceptedPlayers: [Player] = [] {
        didSet {
            contentTableView.reloadData()
        }
    }
    
    private var pendingPlayers: [Player] = [] {
        didSet {
            contentTableView.reloadData()
        }
    }
    
    private var fetchedEvent = BoardlyEvent() {
        didSet {
            contentTableView.reloadData()
        }
    }
    
    private var initialize = true
    
    private var fetchEventDetailsSubject: PublishSubject<Bool>!
    private var kickPlayerSubject: PublishSubject<String>!
    private var acceptPlayerSubject: PublishSubject<String>!
    
    private let adminPresenter = AdminPresenter(adminInteractor: AdminInteractorImpl(adminService: AdminServiceImpl()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTableView.dataSource = self
        contentTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        adminPresenter.bind(adminView: self, eventId: eventId)
        fetchEventDetailsSubject.onNext(initialize)
    }
    
    override func initEmitters() {
        super.initEmitters()
        fetchEventDetailsSubject = PublishSubject()
        kickPlayerSubject = PublishSubject()
        acceptPlayerSubject = PublishSubject()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        initialize = false
        adminPresenter.unbind()
        super.viewWillDisappear(animated)
    }
    
    func render(adminViewState: AdminViewState) {
        if isAdmin {
            showProgressView(show: adminViewState.eventProgress || adminViewState.acceptedProgress || adminViewState.pendingProgress)
            fetchedEvent = adminViewState.event
            acceptedPlayers = adminViewState.acceptedPlayersList
            pendingPlayers = adminViewState.pendingPlayersList
        }
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
    
    func kickPlayerEmitter() -> Observable<String> {
        return kickPlayerSubject
    }
    
    func acceptPlayerEmitter() -> Observable<String> {
        return acceptPlayerSubject
    }
}

extension AdminViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SimpleHeader()
        switch section {
        case 0:
            header.text = "Event info:"
        case 1:
            header.text = "Controls:"
        case 2:
            header.text = "Accepted players:"
        case 3:
            header.text = "Pending players:"
        default:
            return UIView()
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return acceptedPlayers.count
        case 3:
            return pendingPlayers.count
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
            let adminControlCell = getAdminControlCell(indexPath: indexPath)
            return adminControlCell
        case 2:
            let acceptedPlayerCell = getAcceptedPlayerCell(indexPath: indexPath)
            let player = acceptedPlayers[row]
            return acceptedPlayerCell
        case 3:
            let pendingPlayerCell = getPendingPlayerCell(indexPath: indexPath)
            let player = pendingPlayers[row]
            return pendingPlayerCell
        default:
            return getEventViewCell(indexPath: indexPath)
        }
    }
    
    private func getEventViewCell(indexPath: IndexPath) -> BoardlyEventCell {
        return contentTableView.dequeueReusableCell(withIdentifier: EVENT_CELL_ID, for: indexPath) as! BoardlyEventCell
    }
    
    private func getAdminControlCell(indexPath: IndexPath) -> AdminControlCell {
        return contentTableView.dequeueReusableCell(withIdentifier: ADMIN_CONTROL_CELL, for: indexPath) as! AdminControlCell
    }
    
    private func getAcceptedPlayerCell(indexPath: IndexPath) -> AdminAcceptedPlayerCell {
        return contentTableView.dequeueReusableCell(withIdentifier: ADMIN_ACCEPTED_PLAYER_CELL, for: indexPath) as! AdminAcceptedPlayerCell
    }
    
    private func getPendingPlayerCell(indexPath: IndexPath) -> AdminPendingPlayerCell {
        return contentTableView.dequeueReusableCell(withIdentifier: ADMIN_PENDING_PLAYER_CELL, for: indexPath) as! AdminPendingPlayerCell
    }
}
