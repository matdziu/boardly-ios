//
//  NotifyViewRobot.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 24/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//
@testable import Boardly
import Foundation
import Nimble

class NotifyViewRobot {
    
    private let mockNotifyView = MockNotifyView()
    
    init(notifyPresenter: NotifyPresenter) {
        notifyPresenter.bind(notifyView: mockNotifyView)
    }
    
    func assert(expectedViewStates: [NotifyViewState]) {
        expect(self.mockNotifyView.renderedStates).to(equal(expectedViewStates))
    }
    
    func emitGameId(gameId: String) {
        mockNotifyView.gameIdSubject.onNext(gameId)
    }
    
    func emitNotifySettings(notifySettings: NotifySettings) {
        mockNotifyView.notifySettingsSubject.onNext(notifySettings)
    }
    
    func emitStopNotifications() {
        mockNotifyView.stopNotificationsButtonClickSubject.onNext(true)
    }
    
    func emitPlacePickEvent() {
        mockNotifyView.placePickEventSubject.onNext(true)
    }
    
    func triggerNotifySettingsFetch(initialized: Bool) {
        mockNotifyView.notifySettingsFetchSubject.onNext(initialized)
    }
}
