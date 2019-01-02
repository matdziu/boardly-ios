//
//  MockHomeInteractor.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 02/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockHomeInteractor: HomeInteractor {
    
    private var fetchEventsResult = Observable<PartialHomeViewState>.empty()
    private var joinEventResult = Observable<PartialHomeViewState>.empty()
    
    init(fetchEvents: Observable<PartialHomeViewState>,
         joinEvent: Observable<PartialHomeViewState>) {
        self.fetchEventsResult = fetchEvents
        self.joinEventResult = joinEvent
    }
    
    func fetchEvents(userLocation: UserLocation?, radius: Double, gameId: String) -> Observable<PartialHomeViewState> {
        return fetchEventsResult
    }
    
    func joinEvent(joinEventData: JoinEventData) -> Observable<PartialHomeViewState> {
        return joinEventResult
    }
}
