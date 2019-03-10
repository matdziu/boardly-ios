//
//  HomeInteractorImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 02/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

class HomeInteractorImpl: HomeInteractor {
    
    private let homeService: HomeService
    
    init(homeService: HomeService) {
        self.homeService = homeService
        self.homeService.sendClientNotificationToken()
    }
    
    func fetchEvents(userLocation: UserLocation?, radius: Double, gameId: String) -> Observable<PartialHomeViewState> {
        if userLocation == nil {
            return Observable.just(PartialHomeViewState.eventListState(eventList: []))
        } else {
            return Observable.zip(
                homeService.fetchUserEvents(),
                homeService.fetchAllEvents(userLocation: userLocation!, radius: radius, gameId: gameId))
            { userEventsIds, allEvents in
                let filteredEventList = allEvents.filter({ event -> Bool in
                    let userEventPredicate = self.isInsideRadius(userLocation: userLocation!, eventPlaceLatitude: event.placeLatitude, eventPlaceLongitude: event.placeLongitude, radius: radius)
                    if userEventsIds.contains(event.eventId) {
                        return !isOlderThanOneDay(timestamp: event.timestamp) && userEventPredicate
                    } else {
                        return !isOlderThanOneDay(timestamp: event.timestamp)
                    }
                }).map { event -> BoardlyEvent in
                    var modifiedEvent = event
                    if userEventsIds.contains(event.eventId) {
                        modifiedEvent.type = EventType.CREATED
                    }
                    return modifiedEvent
                }
                return PartialHomeViewState.eventListState(eventList: filteredEventList)
            }
        }
    }
    
    private func isInsideRadius(userLocation: UserLocation,
                                eventPlaceLatitude: Double,
                                eventPlaceLongitude: Double,
                                radius: Double) -> Bool {
        let eventLocation = CLLocation(latitude: eventPlaceLatitude, longitude: eventPlaceLongitude)
        let userLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        return eventLocation.distance(from: userLocation) < radius * 1000
    }
    
    func joinEvent(joinEventData: JoinEventData) -> Observable<PartialHomeViewState> {
        return homeService.sendJoinRequest(joinEventData: joinEventData)
            .map({ _ in return PartialHomeViewState.joinRequestSent(render: false)})
            .startWith(PartialHomeViewState.joinRequestSent(render: true))
    }
}
