//
//  MyEventsViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 27/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class MyEventsViewController: BaseJoinEventViewController, MyEventsView {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    @IBOutlet weak var noEventsLabel: UILabel!
    
    private var fetchEventsTriggerSubject = PublishSubject<Bool>()
    private let myEventsPresenter = MyEventsPresenter(myEventsInteractor: MyEventsInteractorImpl(myEventsService: MyEventsServiceImpl()))
    private var refreshWithProgress = true
    private var currentlySelectedIndex = 0
    private let logo = UIImage(named: Image.logo.rawValue)
    
    private var renderedEvents: [BoardlyEvent] = [] {
        didSet {
            eventsTableView.reloadData()
        }
    }
    
    private var acceptedEvents: [BoardlyEvent] = []
    private var pendingEvents: [BoardlyEvent] = []
    private var createdEvents: [BoardlyEvent] = []
    private var interestingEvents: [BoardlyEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        segmentedControl.selectedSegmentIndex = 0
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        eventsTableView.tableFooterView = UIView()
    }
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(named: Color.primaryBlue.rawValue)
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.titleView = UIImageView(image: logo)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        myEventsPresenter.bind(myEventsView: self)
        fetchEventsTriggerSubject.onNext(refreshWithProgress)
        refreshWithProgress = true
    }
    
    private func initEmitters() {
        fetchEventsTriggerSubject = PublishSubject()
        joinEventSubject = PublishSubject()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        myEventsPresenter.unbind()
        super.viewWillDisappear(animated)
    }
    
    func fetchEventsTriggerEmitter() -> Observable<Bool> {
        return fetchEventsTriggerSubject
    }
    
    @IBAction func containerSwitched(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex != currentlySelectedIndex {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.eventsTableView.scrollToTop()
            }
        }
        currentlySelectedIndex = sender.selectedSegmentIndex
        switch sender.selectedSegmentIndex {
        case 0:
            renderedEvents = acceptedEvents
            toggleNoEventsLabel(eventsListSize: acceptedEvents.count, text: NSLocalizedString("No accepted events yet", comment: ""))
        case 1:
            renderedEvents = createdEvents
            toggleNoEventsLabel(eventsListSize: createdEvents.count, text: NSLocalizedString("No created events yet", comment: ""))
        case 2:
            renderedEvents = pendingEvents
            toggleNoEventsLabel(eventsListSize: pendingEvents.count, text: NSLocalizedString("No pending events yet", comment: ""))
        case 3:
            renderedEvents = interestingEvents
            toggleNoEventsLabel(eventsListSize: interestingEvents.count, text: NSLocalizedString("No events that interest you yet", comment: ""))
        default:
            renderedEvents = []
        }
    }
    
    private func toggleNoEventsLabel(eventsListSize: Int, text: String) {
        if eventsListSize == 0 {
            noEventsLabel.isHidden = false
            noEventsLabel.text = text
        } else {
            noEventsLabel.isHidden = true
        }
    }
    
    func render(myEventsViewState: MyEventsViewState) {
        showProgress(show: myEventsViewState.progress)
        acceptedEvents = myEventsViewState.acceptedEvents
        pendingEvents = myEventsViewState.pendingEvents
        createdEvents = myEventsViewState.createdEvents
        interestingEvents = myEventsViewState.interestingEvents
        containerSwitched(segmentedControl)
    }
    
    private func showProgress(show: Bool) {
        if show {
            progressView.startAnimating()
        } else {
            progressView.stopAnimating()
        }
    }
    
    private func enterEvent(event: BoardlyEvent) {
        refreshWithProgress = false
        guard let eventDetailsViewController = storyboard?.instantiateViewController(withIdentifier: EVENT_DETAILS_VIEW_CONTROLLER_ID) as? EventDetailsViewController else { return }
        eventDetailsViewController.prepare(isAdmin: event.type == .CREATED, eventId: event.eventId)
        self.navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
}

extension MyEventsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return renderedEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let boardlyEventCell = eventsTableView.dequeueReusableCell(withIdentifier: EVENT_CELL_ID, for: indexPath) as! BoardlyEventCell
        let event = renderedEvents[indexPath.row]
        boardlyEventCell.bind(event: event, cellClickAction: { self.cellClickAction(event: event) })
        return boardlyEventCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = renderedEvents[indexPath.row]
        cellClickAction(event: event)
    }
    
    private func cellClickAction(event: BoardlyEvent) {
        switch event.type {
        case .CREATED, .ACCEPTED:
            enterEvent(event: event)
        case .PENDING:
            return
        case .DEFAULT:
            joinEvent(eventId: event.eventId)
        }
    }
}
