//
//  MyEventsViewRobot.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 27/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Nimble

class MyEventsViewRobot {
    
    private let mockMyEventsView = MockMyEventsView()
    
    init(myEventsPresenter: MyEventsPresenter) {
        myEventsPresenter.bind(myEventsView: mockMyEventsView)
    }
    
    func assert(expectedViewStates: [MyEventsViewState]) {
        expect(self.mockMyEventsView.renderedStates).to(equal(expectedViewStates))
    }
    
    func triggerEventsFetching(initialize: Bool) {
        mockMyEventsView.fetchEventsTriggerSubject.onNext(initialize)
    }
    
    func joinEvent(joinEventData: JoinEventData) {
        mockMyEventsView.joinEventEmitterSubject.onNext(joinEventData)
    }
}
