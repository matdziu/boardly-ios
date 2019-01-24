//
//  NotifyServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 24/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class NotifyServiceImpl: BaseServiceImpl, NotifyService {
    
    func updateNotifySettings(notifySettings: NotifySettings) -> Observable<Bool> {
        return Observable.empty()
    }
    
    func fetchNotifySettings() -> Observable<NotifySettings> {
        return Observable.empty()
    }
    
    func deleteNotifications() -> Observable<Bool> {
        return Observable.empty()
    }
}
