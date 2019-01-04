//
//  EventContract.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 04/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

protocol EventView {
    
    func render(eventViewState: EventViewState)
    
    func addEventEmitter() -> Observable<EventInputData>
    
    func editEventEmitter() -> Observable<EventInputData>
    
    func deleteEventEmitter() -> Observable<String>
    
    func gamePickEventEmitter() -> Observable<GamePickEvent>
    
    func placePickEventEmitter() -> Observable<Bool>
}

protocol EventInteractor {
    
    func fetchGameDetails(gamePickEvent: GamePickEvent) -> Observable<PartialEventViewState>
    
    func addEvent(inputData: EventInputData) -> Observable<PartialEventViewState>
    
    func editEvent(inputData: EventInputData) -> Observable<PartialEventViewState>
    
    func deleteEvent(eventId: String) -> Observable<PartialEventViewState>
}

protocol EventService {
    
    func addEvent(inputData: EventInputData) -> Observable<Bool>
    
    func editEvent(inputData: EventInputData) -> Observable<Bool>
    
    func deleteEvent(eventId: String) -> Observable<Bool>
}
