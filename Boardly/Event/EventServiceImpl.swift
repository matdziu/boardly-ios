//
//  EventServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 12/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class EventServiceImpl: EventService {
    
    func addEvent(inputData: EventInputData) -> Observable<Bool> {
        return Observable.empty()
    }
    
    func editEvent(inputData: EventInputData) -> Observable<Bool> {
        return Observable.empty()
    }
    
    func deleteEvent(eventId: String) -> Observable<Bool> {
        return Observable.empty()
    }
}
