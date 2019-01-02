//
//  MockHomeService.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 02/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockHomeService: HomeService {
    
    private var fetchAllEventsResult = Observable<[BoardlyEvent]>.empty()
    private var fetchCreatedEventsResult = Observable<[BoardlyEvent]>.empty()
    private var fetchUserEventsResult = Observable<[String]>.empty()
    private var sendJoinRequestResult = Observable<Bool>.empty()
    
    init(fetchAllEvents: Observable<[BoardlyEvent]>,
         fetchCreatedEvents: Observable<[BoardlyEvent]>,
         fetchUserEvents: Observable<[String]>,
         sendJoinRequest: Observable<Bool>) {
        self.fetchAllEventsResult = fetchAllEvents
        self.fetchCreatedEventsResult = fetchCreatedEvents
        self.fetchUserEventsResult = fetchUserEvents
        self.sendJoinRequestResult = sendJoinRequest
    }
    
    func sendClientNotificationToken() {
        // unused in tests
    }
    
    func fetchAllEvents(userLocation: UserLocation, radius: Double, gameId: String) -> Observable<[BoardlyEvent]> {
        return fetchAllEventsResult
    }
    
    func fetchCreatedEvents() -> Observable<[BoardlyEvent]> {
        return fetchCreatedEventsResult
    }
    
    func fetchUserEvents() -> Observable<[String]> {
        return fetchUserEventsResult
    }
    
    func sendJoinRequest(joinEventData: JoinEventData) -> Observable<Bool> {
        return sendJoinRequestResult
    }
}
