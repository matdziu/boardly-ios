//
//  DiscoverInteractorImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class DiscoverInteractorImpl: DiscoverInteractor {
    
    private let discoverService: DiscoverService
    
    init(discoverService: DiscoverService) {
        self.discoverService = discoverService
    }
    
    func fetchPlacesList(userLocation: UserLocation, radius: Double) -> Observable<PartialDiscoverViewState> {
        return discoverService.fetchPlacesList(userLocation: userLocation, radius: radius)
            .map { PartialDiscoverViewState.placesListFetched(placesList: $0) }
    }
}
