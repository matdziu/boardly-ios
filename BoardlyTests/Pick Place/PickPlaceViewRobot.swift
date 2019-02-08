//
//  PickPlaceViewRobot.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 08/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Nimble

class PickPlaceViewRobot {
    
    private let mockPickPlaceView = MockPickPlaceView()
    
    init(pickPlacePresenter: PickPlacePresenter) {
        pickPlacePresenter.bind(pickPlaceView: mockPickPlaceView)
    }
    
    func assert(expectedViewStates: [PickPlaceViewState]) {
        expect(self.mockPickPlaceView.renderedStates).to(equal(expectedViewStates))
    }
    
    func emitQuery(query: String) {
        mockPickPlaceView.querySubject.onNext(query)
    }
}

