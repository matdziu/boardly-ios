//
//  EventViewRobot.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 04/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Nimble

class EventViewRobot {
    
    private let mockEventView = MockEventView()
    
    init(eventPresenter: EventPresenter) {
        eventPresenter.bind(eventView: mockEventView)
    }
    
    func assert(expectedViewStates: [EventViewState]) {
        expect(self.mockEventView.renderedStates).to(equal(expectedViewStates))
    }
    
    func addEvent(inputData: EventInputData) {
        mockEventView.addEventSubject.onNext(inputData)
    }
    
    func pickGame(gamePickEvent: GamePickEvent) {
        mockEventView.gamePickEventSubject.onNext(gamePickEvent)
    }
    
    func pickPlace() {
        mockEventView.placePickEventSubject.onNext(true)
    }
    
    func editEvent(inputData: EventInputData) {
        mockEventView.editEventSubject.onNext(inputData)
    }
    
    func deleteEvent(eventId: String) {
        mockEventView.deleteEventSubject.onNext(eventId)
    }
}
