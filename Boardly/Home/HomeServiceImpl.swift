//
//  HomeServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 17/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class HomeServiceImpl: HomeService {
    
    func sendClientNotificationToken() {
        
    }
    
    func fetchAllEvents(userLocation: UserLocation, radius: Double, gameId: String) -> Observable<[BoardlyEvent]> {
        return Observable.empty()
    }
    
    func fetchCreatedEvents() -> Observable<[BoardlyEvent]> {
        return Observable.empty()
    }
    
    func fetchUserEvents() -> Observable<[String]> {
        return Observable.empty()
    }
    
    func sendJoinRequest(joinEventData: JoinEventData) -> Observable<Bool> {
        // move to BaseServiceImpl
        return Observable.empty()
    }
}
