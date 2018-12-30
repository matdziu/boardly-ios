//
//  FilterViewRobot.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 30/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Nimble

class FilterViewRobot {
    
    private let mockFilterView = MockFilterView()
    
    init(filterPresenter: FilterPresenter) {
        filterPresenter.bind(filterView: mockFilterView)
    }
    
    func assert(expectedViewStates: [FilterViewState]) {
        expect(self.mockFilterView.renderedStates).to(equal(expectedViewStates))
    }
    
    func emitGameId(gameId: String) {
        mockFilterView.gameIdSubject.onNext(gameId)
    }
    
    func emitLocationProcessing(processing: Bool) {
        mockFilterView.locationProcessingSubject.onNext(processing)
    }
}
