//
//  MockMyEventsService.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 27/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockMyEventsService: MyEventsService {
    
    private var getPendingEventsResult = Observable<[BoardlyEvent]>.empty()
    private var getAcceptedEventsResult = Observable<[BoardlyEvent]>.empty()
    private var getInterestingEventsResult = Observable<[BoardlyEvent]>.empty()
    private var getCreatedEventsResult = Observable<[BoardlyEvent]>.empty()
    private var sendJoinRequestResult = Observable<Bool>.empty()
    
    init(getPendingEvents: Observable<[BoardlyEvent]> = Observable.empty(),
         getAcceptedEvents: Observable<[BoardlyEvent]> = Observable.empty(),
         getInterestingEvents: Observable<[BoardlyEvent]> = Observable.empty(),
         getCreatedEvents: Observable<[BoardlyEvent]> = Observable.empty(),
         sendJoinRequest: Observable<Bool> = Observable.empty()) {
        self.getInterestingEventsResult = getInterestingEvents
        self.getAcceptedEventsResult = getAcceptedEvents
        self.getPendingEventsResult = getPendingEvents
        self.getCreatedEventsResult = getCreatedEvents
        self.sendJoinRequestResult = sendJoinRequest
    }
    
    func getPendingEvents() -> Observable<[BoardlyEvent]> {
        return getPendingEventsResult
    }
    
    func getAcceptedEvents() -> Observable<[BoardlyEvent]> {
        return getAcceptedEventsResult
    }
    
    func getCreatedEvents() -> Observable<[BoardlyEvent]> {
        return getCreatedEventsResult
    }
    
    func getInterestingEvents() -> Observable<[BoardlyEvent]> {
        return getInterestingEventsResult
    }
    
    func sendJoinRequest(joinEventData: JoinEventData) -> Observable<Bool> {
        return sendJoinRequestResult
    }
}
