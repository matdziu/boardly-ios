//
//  MockDiscoverService.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockDiscoverService: DiscoverService {
    
    private var fetchPlacesListResult: Observable<[BoardlyPlace]> = Observable.empty()
    
    init(fetchPlacesList: Observable<[BoardlyPlace]> = Observable.empty()) {
        self.fetchPlacesListResult = fetchPlacesList
    }
    
    func fetchPlacesList(userLocation: UserLocation, radius: Double) -> Observable<[BoardlyPlace]> {
        return fetchPlacesListResult
    }
}
