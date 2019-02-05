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
    
    private let playersPresenter = PlayersPresenter(playersInteractor: PlayersInteractorImpl(playersService: PlayersServiceImpl()))
    private var initialize = true
    
    private var leaveEventSubject: PublishSubject<Bool>!
    private var fetchEventDetailsSubject: PublishSubject<Bool>!
    
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
        
    }
    
    func fetchEventDetailsTriggerEmitter() -> Observable<Bool> {
        return Observable.empty()
    }
    
    func leaveEventEmitter() -> Observable<Bool> {
        return Observable.empty()
    }
}
