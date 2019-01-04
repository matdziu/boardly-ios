//
//  MockEventView.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 04/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockEventView: EventView {
    
    var renderedStates: [EventViewState] = []
    let addEventSubject = PublishSubject<EventInputData>()
    let editEventSubject = PublishSubject<EventInputData>()
    let deleteEventSubject = PublishSubject<String>()
    let gamePickEventSubject = PublishSubject<GamePickEvent>()
    let placePickEventSubject = PublishSubject<Bool>()
    
    func render(eventViewState: EventViewState) {
        renderedStates.append(eventViewState)
    }
    
    func addEventEmitter() -> Observable<EventInputData> {
        return addEventSubject
    }
    
    func editEventEmitter() -> Observable<EventInputData> {
        return editEventSubject
    }
    
    func deleteEventEmitter() -> Observable<String> {
        return deleteEventSubject
    }
    
    func gamePickEventEmitter() -> Observable<GamePickEvent> {
        return gamePickEventSubject
    }
    
    func placePickEventEmitter() -> Observable<Bool> {
        return placePickEventSubject
    }
}
