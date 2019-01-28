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

class MyEventsViewController: UIViewController, MyEventsView {
    
    @IBOutlet weak var acceptedContainer: UIView!
    @IBOutlet weak var createdContainer: UIView!
    @IBOutlet weak var pendingContainer: UIView!
    @IBOutlet weak var interestingContainer: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private var containerViews: [UIView] = []
    
    private var fetchEventsTriggerSubject = PublishSubject<Bool>()
    private var joinEventSubject = PublishSubject<JoinEventData>()
    private let myEventsPresenter = MyEventsPresenter(myEventsInteractor: MyEventsInteractorImpl(myEventsService: MyEventsServiceImpl()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerViews = [acceptedContainer, createdContainer, pendingContainer, interestingContainer]
        segmentedControl.selectedSegmentIndex = 0
        showOnly(acceptedContainer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        myEventsPresenter.bind(myEventsView: self)
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
    
    func joinEventEmitter() -> Observable<JoinEventData> {
        return joinEventSubject
    }
    
    @IBAction func containerSwitched(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showOnly(acceptedContainer)
        case 1:
            showOnly(createdContainer)
        case 2:
            showOnly(pendingContainer)
        case 3:
            showOnly(interestingContainer)
        default:
            showOnly(acceptedContainer)
        }
    }
    
    private func showOnly(_ container: UIView) {
        for item in containerViews {
            if item == container {
                item.alpha = 1
            } else {
                item.alpha = 0
            }
        }
    }
    
    func render(myEventsViewState: MyEventsViewState) {
        
    }
}
