//
//  NotifyViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 24/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class NotifyViewController: UIViewController, NotifyView {
    
    private var gameIdSubject: PublishSubject<String>!
    private var notifySettingsFetchSubject: PublishSubject<Bool>!
    private var placePickEventSubject: PublishSubject<Bool>!
    
    private var initialize = true
    
    private let notifyPresenter = NotifyPresenter(notifyInteractor: NotifyInteractorImpl(gameService: GameServiceImpl(), notifyService: NotifyServiceImpl()))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        notifyPresenter.bind(notifyView: self)
    }
    
    private func initEmitters() {
        gameIdSubject = PublishSubject()
        notifySettingsFetchSubject = PublishSubject()
        placePickEventSubject = PublishSubject()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        initialize = false
        notifyPresenter.unbind()
        super.viewWillDisappear(animated)
    }
    
    func gameIdEmitter() -> Observable<String> {
        return gameIdSubject
    }
    
    func notifySettingsEmitter() -> Observable<NotifySettings> {
        // rxcocoa here
        return Observable.empty()
    }
    
    func notifySettingsFetchEmitter() -> Observable<Bool> {
        return notifySettingsFetchSubject
    }
    
    func stopNotificationsButtonClickEmitter() -> Observable<Bool> {
        // rxcocoa here
        return Observable.empty()
    }
    
    func placePickEventEmitter() -> Observable<Bool> {
        return placePickEventSubject
    }
    
    func render(notifyViewState: NotifyViewState) {
        
    }
}
