//
//  MockEventInteractor.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 04/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockEventInteractor: EventInteractor {
    
    private var fetchGameDetailsResult = Observable<PartialEventViewState>.empty()
    private var addEventResult = Observable<PartialEventViewState>.empty()
    private var editEventResult = Observable<PartialEventViewState>.empty()
    private var deleteEventResult = Observable<PartialEventViewState>.empty()
    
    init(fetchGameDetails: Observable<PartialEventViewState> = Observable.empty(),
         addEvent: Observable<PartialEventViewState> = Observable.empty(),
         editEvent: Observable<PartialEventViewState> = Observable.empty(),
         deleteEvent: Observable<PartialEventViewState> = Observable.empty()) {
        self.fetchGameDetailsResult = fetchGameDetails
        self.addEventResult = addEvent
        self.editEventResult = editEvent
        self.deleteEventResult = deleteEvent
    }
    
    func fetchGameDetails(gamePickEvent: GamePickEvent) -> Observable<PartialEventViewState> {
        return fetchGameDetailsResult
    }
    
    func addEvent(inputData: EventInputData) -> Observable<PartialEventViewState> {
        return addEventResult
    }
    
    func editEvent(inputData: EventInputData) -> Observable<PartialEventViewState> {
        return editEventResult
    }
    
    func deleteEvent(eventId: String) -> Observable<PartialEventViewState> {
        return deleteEventResult
    }
}
