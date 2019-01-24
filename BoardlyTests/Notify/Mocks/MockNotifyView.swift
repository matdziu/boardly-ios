//
//  MockNotifyView.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 24/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockNotifyView: NotifyView {
    
    var renderedStates: [NotifyViewState] = []
    let gameIdSubject = PublishSubject<String>()
    let notifySettingsSubject = PublishSubject<NotifySettings>()
    let notifySettingsFetchSubject = PublishSubject<Bool>()
    let stopNotificationsButtonClickSubject = PublishSubject<Bool>()
    let placePickEventSubject = PublishSubject<Bool>()
    
    func render(notifyViewState: NotifyViewState) {
        renderedStates.append(notifyViewState)
    }
    
    func gameIdEmitter() -> Observable<String> {
        return gameIdSubject
    }
    
    func notifySettingsEmitter() -> Observable<NotifySettings> {
        return notifySettingsSubject
    }
    
    func notifySettingsFetchEmitter() -> Observable<Bool> {
        return notifySettingsFetchSubject
    }
    
    func stopNotificationsButtonClickEmitter() -> Observable<Bool> {
        return stopNotificationsButtonClickSubject
    }
    
    func placePickEventEmitter() -> Observable<Bool> {
        return placePickEventSubject
    }
}
