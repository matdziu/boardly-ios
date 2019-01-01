//
//  PickGameRobot.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 31/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Nimble

class PickGameViewRobot {
    
    private let mockPickGameView = MockPickGameView()
    
    init(pickGamePresenter: PickGamePresenter) {
        pickGamePresenter.bind(pickGameView: mockPickGameView)
    }
    
    func assert(expectedViewStates: [PickGameViewState]) {
        expect(self.mockPickGameView.renderedStates).to(equal(expectedViewStates))
    }
    
    func emitQuery(query: String) {
        mockPickGameView.querySubject.onNext(query)
    }
}
