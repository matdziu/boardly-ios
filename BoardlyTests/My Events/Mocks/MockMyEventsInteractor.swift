//
//  MockMyEventsInteractor.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 27/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockMyEventsInteractor: MyEventsInteractor {
    
    private var fetchEventsResult = Observable<PartialMyEventsViewState>.empty()
    private var joinEventResult = Observable<PartialMyEventsViewState>.empty()
    
    init(fetchEvents: Observable<PartialMyEventsViewState> = Observable.empty(),
         joinEvent: Observable<PartialMyEventsViewState> = Observable.empty()) {
        self.fetchEventsResult = fetchEvents
        self.joinEventResult = joinEvent
    }
    
    func fetchEvents() -> Observable<PartialMyEventsViewState> {
        return fetchEventsResult
    }
    
    func joinEvent(joinEventData: JoinEventData) -> Observable<PartialMyEventsViewState> {
        return joinEventResult
    }
}
