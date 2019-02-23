//
//  DiscoverContract.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

protocol DiscoverView {
    
    func fetchPlacesListTrigger() -> Observable<PlaceFilteredFetchData>
    
    func render(discoverViewState: DiscoverViewState)
}

protocol DiscoverService {
    
    func fetchPlacesList(userLocation: UserLocation, radius: Double) -> Observable<[BoardlyPlace]>
}

protocol DiscoverInteractor {
    
    func fetchPlacesList(userLocation: UserLocation, radius: Double) -> Observable<PartialDiscoverViewState>
}
