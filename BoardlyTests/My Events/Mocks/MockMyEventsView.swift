//
//  MockMyEventsView.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 27/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockMyEventsView: MyEventsView {
    
    var renderedStates: [MyEventsViewState] = []
    let fetchEventsTriggerSubject = PublishSubject<Bool>()
    let joinEventEmitterSubject = PublishSubject<JoinEventData>()
    
    func render(myEventsViewState: MyEventsViewState) {
        renderedStates.append(myEventsViewState)
    }
    
    func fetchEventsTriggerEmitter() -> Observable<Bool> {
        return fetchEventsTriggerSubject
    }
    
    func joinEventEmitter() -> Observable<JoinEventData> {
        return joinEventEmitterSubject
    }
}
