//
//  MockNotifyInteractor.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 24/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockNotifyInteractor: NotifyInteractor {
    
    private var fetchGameDetailsResult = Observable<PartialNotifyViewState>.empty()
    private var updateNotifySettingsResult = Observable<PartialNotifyViewState>.empty()
    private var fetchNotifySettingsResult = Observable<PartialNotifyViewState>.empty()
    private var deleteNotificationsResult = Observable<PartialNotifyViewState>.empty()
    
    init(fetchGameDetails: Observable<PartialNotifyViewState> = Observable.empty(),
         updateNotifySettings: Observable<PartialNotifyViewState> = Observable.empty(),
         fetchNotifySettings: Observable<PartialNotifyViewState> = Observable.empty(),
         deleteNotifications: Observable<PartialNotifyViewState> = Observable.empty()) {
        self.fetchGameDetailsResult = fetchGameDetails
        self.updateNotifySettingsResult = updateNotifySettings
        self.fetchNotifySettingsResult = fetchNotifySettings
        self.deleteNotificationsResult = deleteNotifications
    }
    
    func fetchGameDetails(gameId: String) -> Observable<PartialNotifyViewState> {
        return fetchGameDetailsResult
    }
    
    func updateNotifySettings(notifySettings: NotifySettings) -> Observable<PartialNotifyViewState> {
        return updateNotifySettingsResult
    }
    
    func fetchNotifySettings() -> Observable<PartialNotifyViewState> {
        return fetchNotifySettingsResult
    }
    
    func deleteNotifications() -> Observable<PartialNotifyViewState> {
        return deleteNotificationsResult
    }
}
