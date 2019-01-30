//
//  PlayersViewRobot.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Nimble

class PlayersViewRobot {
    
    private let mockPlayersView = MockPlayersView()
    
    init(playersPresenter: PlayersPresenter, eventId: String) {
        playersPresenter.bind(playersView: mockPlayersView, eventId: eventId)
    }
    
    func assert(expectedViewStates: [PlayersViewState]) {
        expect(self.mockPlayersView.renderedStates).to(equal(expectedViewStates))
    }
    
    func triggerEventDetailsFetching() {
        mockPlayersView.fetchEventDetailsTriggerSubject.onNext(true)
    }
    
    func emitRating(rateInput: RateInput) {
        mockPlayersView.emitRating(rateInput: rateInput)
    }
    
    func leaveEvent() {
        mockPlayersView.leaveEventSubject.onNext(true)
    }
}
