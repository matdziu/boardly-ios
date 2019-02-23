//
//  DiscoverViewRobot.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Nimble

class DiscoverViewRobot {
    
    private let discoverView = MockDiscoverView()
    
    init(discoverPresenter: DiscoverPresenter) {
        discoverPresenter.bind(discoverView: discoverView)
    }
    
    func assert(expectedViewStates: [DiscoverViewState]) {
        expect(self.discoverView.renderedStates).to(equal(expectedViewStates))
    }
    
    func triggerPlacesFetch(placeFilteredFetchData: PlaceFilteredFetchData) {
        discoverView.fetchPlacesListTriggerSubject.onNext(placeFilteredFetchData)
    }
}
