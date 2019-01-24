//
//  NotifyContract.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 24/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

protocol NotifyView {
    
    func render(notifyViewState: NotifyViewState)
    
    func gameIdEmitter() -> Observable<String>
    
    func notifySettingsEmitter() -> Observable<NotifySettings>
    
    func notifySettingsFetchEmitter() -> Observable<Bool>
    
    func stopNotificationsButtonClickEmitter() -> Observable<Bool>
    
    func placePickEventEmitter() -> Observable<Bool>
}

protocol NotifyInteractor {
    
    func fetchGameDetails(gameId: String) -> Observable<PartialNotifyViewState>
    
    func updateNotifySettings(notifySettings: NotifySettings) -> Observable<PartialNotifyViewState>
    
    func fetchNotifySettings() -> Observable<PartialNotifyViewState>
    
    func deleteNotifications() -> Observable<PartialNotifyViewState>
}

protocol NotifyService {
    
    func updateNotifySettings(notifySettings: NotifySettings) -> Observable<Bool>
    
    func fetchNotifySettings() -> Observable<NotifySettings>
    
    func deleteNotifications() -> Observable<Bool>
}
