//
//  MockNotifyService.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 25/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockNotifyService: NotifyService {
    
    private var updateNotifySettingsResult = Observable<Bool>.empty()
    private var fetchNotifySettingsResult = Observable<NotifySettings>.empty()
    private var deleteNotificationsResult = Observable<Bool>.empty()
    
    init(updateNotifySettings: Observable<Bool> = Observable.empty(),
         fetchNotifySettings: Observable<NotifySettings> = Observable.empty(),
         deleteNotifications: Observable<Bool> = Observable.empty()) {
        self.updateNotifySettingsResult = updateNotifySettings
        self.fetchNotifySettingsResult = fetchNotifySettings
        self.deleteNotificationsResult = deleteNotifications
    }
    
    func updateNotifySettings(notifySettings: NotifySettings) -> Observable<Bool> {
        return updateNotifySettingsResult
    }
    
    func fetchNotifySettings() -> Observable<NotifySettings> {
        return fetchNotifySettingsResult
    }
    
    func deleteNotifications() -> Observable<Bool> {
        return deleteNotificationsResult
    }
}
