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
    
    private var fetchEventsTriggerSubject = PublishSubject<Bool>()
    private var joinEventSubject = PublishSubject<JoinEventData>()
    private let myEventsPresenter = MyEventsPresenter(myEventsInteractor: MyEventsInteractorImpl(myEventsService: MyEventsServiceImpl()))
    
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
    
    func render(myEventsViewState: MyEventsViewState) {
        
    }
}
