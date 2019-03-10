//
//  DiscoverServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 23/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

class DiscoverServiceImpl: BaseServiceImpl, DiscoverService {
    
    func fetchPlacesList(userLocation: UserLocation, radius: Double) -> Observable<[BoardlyPlace]> {
        let resultSubject = PublishSubject<[BoardlyPlace]>()
        var fetchedPlacesList: [BoardlyPlace] = []
        var geoFetchedPlacesIds: [String] = []
        
        let query = getGeoFire(childPath: PLACES_NODE).query(at: CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude), withRadius: radius)
        query.observe(.keyEntered) { (key, location) in
            geoFetchedPlacesIds.append(key)
        }
        query.observeReady {
            if geoFetchedPlacesIds.count == 0 {
                resultSubject.onNext([])
            }
            for placeId in geoFetchedPlacesIds {
                self.getSinglePlaceRef(placeId: placeId).observeSingleEvent(of: .value, with: { snapshot in
                    let place = BoardlyPlace(snapshot: snapshot)
                    fetchedPlacesList.append(place)
                    if fetchedPlacesList.count == geoFetchedPlacesIds.count {
                        fetchedPlacesList.shuffle()
                        resultSubject.onNext(fetchedPlacesList)
                    }
                })
            }
        }
        
        return resultSubject
    }
}
