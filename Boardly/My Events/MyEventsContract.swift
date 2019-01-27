//
//  MyEventsContract.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 27/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

protocol MyEventsView: BaseJoinEventView {
    
    func render(myEventsViewState: MyEventsViewState)
    
    func fetchEventsTriggerEmitter() -> Observable<Bool>
}

protocol MyEventsInteractor {
    
    func fetchEvents() -> Observable<PartialMyEventsViewState>
    
    func joinEvent(joinEventData: JoinEventData) -> Observable<PartialMyEventsViewState>
}

protocol MyEventsService {
    
    func getPendingEvents() -> Observable<[BoardlyEvent]>
    
    func getAcceptedEvents() -> Observable<[BoardlyEvent]>
    
    func getCreatedEvents() -> Observable<[BoardlyEvent]>
    
    func getInterestingEvents() -> Observable<[BoardlyEvent]>
    
    func sendJoinRequest(joinEventData: JoinEventData) -> Observable<Bool>
}
