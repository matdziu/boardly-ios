//
//  HomeContract.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 02/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeView: BaseJoinEventView {
    
    func render(homeViewState: HomeViewState)
    
    func filteredFetchTriggerEmitter() -> Observable<FilteredFetchData>
    
    func locationProcessingEmitter() -> Observable<Bool>
}

protocol HomeInteractor {
    
    func fetchEvents(userLocation: UserLocation?,
                     radius: Double,
                     gameId: String) -> Observable<PartialHomeViewState>
    
    func joinEvent(joinEventData: JoinEventData) -> Observable<PartialHomeViewState>
}

protocol HomeService {
    
    func sendClientNotificationToken()
    
    func fetchAllEvents(userLocation: UserLocation,
                        radius: Double,
                        gameId: String) -> Observable<[BoardlyEvent]>
    
    func fetchCreatedEvents() -> Observable<[BoardlyEvent]>
    
    func fetchUserEvents() -> Observable<[String]>
    
    func sendJoinRequest(joinEventData: JoinEventData) -> Observable<Bool>
}
