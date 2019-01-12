//
//  EventViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 12/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class EventViewController: UIViewController, EventView {
    
    private let eventPresenter = EventPresenter(eventInteractor: EventInteractorImpl(gameService: GameServiceImpl(), eventService: EventServiceImpl()))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        eventPresenter.bind(eventView: self)
    }
    
    private func initEmitters() {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        eventPresenter.unbind()
        super.viewWillDisappear(animated)
    }
    
    func addEventEmitter() -> Observable<EventInputData> {
        return Observable.empty()
    }
    
    func editEventEmitter() -> Observable<EventInputData> {
        return Observable.empty()
    }
    
    func deleteEventEmitter() -> Observable<String> {
        return Observable.empty()
    }
    
    func gamePickEventEmitter() -> Observable<GamePickEvent> {
        return Observable.empty()
    }
    
    func placePickEventEmitter() -> Observable<Bool> {
        return Observable.empty()
    }
    
    func render(eventViewState: EventViewState) {
        
    }
}
