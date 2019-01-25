//
//  NotifyServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 24/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

class NotifyServiceImpl: BaseServiceImpl, NotifyService {
    
    func updateNotifySettings(notifySettings: NotifySettings) -> Observable<Bool> {
        let userLatitude = notifySettings.userLatitude
        let userLongitude = notifySettings.userLongitude
        if userLatitude != nil && userLongitude != nil {
            let geoLocation = CLLocation(latitude: userLatitude!, longitude: userLongitude!)
            return setGeoLocation(location: geoLocation)
                .flatMap({ _ -> Observable<Bool> in
                    let resultSubject = PublishSubject<Bool>()
                    self.getUserNotifySettingsRef(userId: self.getCurrentUserId())
                        .updateChildValues(notifySettings.toDict(), withCompletionBlock: { (error, _) in
                            if error == nil {
                                resultSubject.onNext(true)
                            } else {
                                resultSubject.onError(error!)
                            }})
                    return resultSubject
                })
        } else {
            return Observable.empty()
        }
    }
    
    func fetchNotifySettings() -> Observable<NotifySettings> {
        let resultSubject = PublishSubject<NotifySettings>()
        getUserNotifySettingsRef(userId: getCurrentUserId()).observeSingleEvent(of: .value) { snapshot in
            let notifySettings = NotifySettings(snapshot: snapshot)
            resultSubject.onNext(notifySettings)
        }
        return resultSubject
    }
    
    func deleteNotifications() -> Observable<Bool> {
        let resultSubject = PublishSubject<Bool>()
        getUserNotifySettingsRef(userId: getCurrentUserId()).setValue(nil) { (error, _) in
            if error == nil {
                resultSubject.onNext(true)
            }
        }
        return resultSubject
    }
    
    private func setGeoLocation(location: CLLocation) -> Observable<Bool> {
        let resultSubject = PublishSubject<Bool>()
        getGeoFire(childPath: NOTIFY_SETTINGS_NODE).setLocation(location, forKey: getCurrentUserId()) { error in
            if error == nil {
                resultSubject.onNext(true)
            } else {
                resultSubject.onError(error!)
            }
        }
        return resultSubject
    }
}
