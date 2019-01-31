//
//  AdminViewRobot.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 31/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Nimble

class AdminViewRobot {
    
    private let mockAdminView = MockAdminView()
    
    init(adminPresenter: AdminPresenter, eventId: String) {
        adminPresenter.bind(adminView: mockAdminView, eventId: eventId)
    }
    
    func assert(expectedViewStates: [AdminViewState]) {
        expect(self.mockAdminView.renderedStates).to(equal(expectedViewStates))
    }
    
    func triggerEventPlayersFetching() {
        mockAdminView.fetchEventDetailsTriggerSubject.onNext(true)
    }
    
    func kickPlayer(playerId: String) {
        mockAdminView.kickPlayerSubject.onNext(playerId)
    }
    
    func acceptPlayer(playerId: String) {
        mockAdminView.acceptPlayerSubject.onNext(playerId)
    }
    
    func emitRating(rateInput: RateInput) {
        mockAdminView.emitRating(rateInput: rateInput)
    }
}
