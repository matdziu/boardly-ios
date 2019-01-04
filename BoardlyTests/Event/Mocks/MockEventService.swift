//
//  MockEventService.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 04/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockEventService: EventService {
    
    private var addEventResult = Observable<Bool>.empty()
    private var editEventResult = Observable<Bool>.empty()
    private var deleteEventResult = Observable<Bool>.empty()
    
    init(addEvent: Observable<Bool> = Observable.empty(),
         editEvent: Observable<Bool> = Observable.empty(),
         deleteEvent: Observable<Bool> = Observable.empty()) {
        self.addEventResult = addEvent
        self.editEventResult = editEvent
        self.deleteEventResult = deleteEvent
    }
    
    func addEvent(inputData: EventInputData) -> Observable<Bool> {
        return addEventResult
    }
    
    func editEvent(inputData: EventInputData) -> Observable<Bool> {
        return editEventResult
    }
    
    func deleteEvent(eventId: String) -> Observable<Bool> {
        return deleteEventResult
    }
}
