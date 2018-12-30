//
//  FilterPresenterTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 30/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick

class FilterPresenterTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        var filterPresenter: FilterPresenter!
        var filterViewRobot: FilterViewRobot!
        var mockFilterInteractor: MockFilterInterator!
        
        beforeEach {
            mockFilterInteractor = MockFilterInterator()
            filterPresenter = FilterPresenter(filterInteractor: mockFilterInteractor)
            filterViewRobot = FilterViewRobot(filterPresenter: filterPresenter)
        }
        
        describe("FilterPresenter") {
            
            it("successful game details fetching") {
                filterViewRobot.emitGameId(gameId: "testGameId")
                filterViewRobot.assert(expectedViewStates: [
                    FilterViewState(),
                    FilterViewState(gameImageUrl: mockFilterInteractor!.testGame.image)])
            }
            
            it("renders correct location processing state") {
                filterViewRobot.emitLocationProcessing(processing: true)
                filterViewRobot.emitLocationProcessing(processing: false)
                filterViewRobot.assert(expectedViewStates: [
                    FilterViewState(),
                    FilterViewState(locationProcessing: true),
                    FilterViewState(locationProcessing: false)])
            }
        }
    }
}
