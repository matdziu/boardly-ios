//
//  MockDiscoverInteractor.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockDiscoverInteractor: DiscoverInteractor {
    
    private var fetchPlacesListResult: Observable<PartialDiscoverViewState> = Observable.empty()
    
    init(fetchPlacesList: Observable<PartialDiscoverViewState> = Observable.empty()) {
        self.fetchPlacesListResult = fetchPlacesList
    }
    
    func fetchPlacesList(userLocation: UserLocation, radius: Double) -> Observable<PartialDiscoverViewState> {
        return fetchPlacesListResult
    }
}
