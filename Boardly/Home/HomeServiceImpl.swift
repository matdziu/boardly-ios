//
//  HomeServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 17/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

class HomeServiceImpl: BaseServiceImpl, HomeService {
    
    func sendClientNotificationToken() {
        
    }
    
    func fetchAllEvents(userLocation: UserLocation, radius: Double, gameId: String) -> Observable<[BoardlyEvent]> {
        let resultSubject = PublishSubject<[BoardlyEvent]>()
        var fetchedEventsList: [BoardlyEvent] = []
        var dataFetchedEventsIds: [String] = []
        var geoFetchedEventsIds: [String] = []
        
        let query = getGeoFire(childPath: EVENTS_NODE).query(at: CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude), withRadius: radius)
        query.observe(.keyEntered) { (key, location) in
            geoFetchedEventsIds.append(key)
        }
        query.observeReady {
            if geoFetchedEventsIds.count == 0 {
                resultSubject.onNext([])
            }
            for eventId in geoFetchedEventsIds {
                self.getSingleEventNodeRef(eventId: eventId).observeSingleEvent(of: .value, with: { snapshot in
                    let event = BoardlyEvent(snapshot: snapshot)
                    if gameId.isEmpty ||
                        event.gameId == gameId ||
                        event.gameId2 == gameId ||
                        event.gameId3 == gameId {
                        fetchedEventsList.append(event)
                    }
                    dataFetchedEventsIds.append(eventId)
                    if dataFetchedEventsIds.count == geoFetchedEventsIds.count {
                        resultSubject.onNext(fetchedEventsList.reversed())
                    }
                })
            }
        }
        
        return resultSubject
    }
    
    func fetchCreatedEvents() -> Observable<[BoardlyEvent]> {
        return createdEventIdsList().flatMap { return self.events(idsList: $0) }
    }
    
    func fetchUserEvents() -> Observable<[String]> {
        return Observable.zip(pendingEventIdsList(), acceptedEventIdsList(), createdEventIdsList()) { (pending, accepted, created) in return pending + accepted + created
        }
    }
}
