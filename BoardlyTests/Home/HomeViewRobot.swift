//
//  HomeViewRobot.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 02/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Nimble

class HomeViewRobot {
    
    private let mockHomeView = MockHomeView()
    
    init(homePresenter: HomePresenter) {
        homePresenter.bind(homeView: mockHomeView)
    }
    
    func assert(expectedViewStates: [HomeViewState]) {
        expect(self.mockHomeView.renderedStates).to(equal(expectedViewStates))
    }
    
    func triggerFilteredFetch(filteredFetchData: FilteredFetchData) {
        mockHomeView.filteredFetchTriggerSubject.onNext(filteredFetchData)
    }
    
    func emitLocationProcessing(processing: Bool) {
        mockHomeView.locationProcessingSubject.onNext(processing)
    }
    
    func joinEvent(joinEventData: JoinEventData) {
        mockHomeView.joinEventSubject.onNext(joinEventData)
    }
}
