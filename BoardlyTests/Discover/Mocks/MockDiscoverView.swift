//
//  MockDiscoverView.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockDiscoverView: DiscoverView {
    
    var renderedStates: [DiscoverViewState] = []
    let fetchPlacesListTriggerSubject = PublishSubject<PlaceFilteredFetchData>()
    
    func fetchPlacesListTrigger() -> Observable<PlaceFilteredFetchData> {
        return fetchPlacesListTriggerSubject
    }
    
    func render(discoverViewState: DiscoverViewState) {
        renderedStates.append(discoverViewState)
    }
}
