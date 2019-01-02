//
//  MockHomeView.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 02/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockHomeView: HomeView {
    
    var renderedStates: [HomeViewState] = []
    let filteredFetchTriggerSubject = PublishSubject<FilteredFetchData>()
    let locationProcessingSubject = PublishSubject<Bool>()
    let joinEventSubject = PublishSubject<JoinEventData>()
    
    func render(homeViewState: HomeViewState) {
        renderedStates.append(homeViewState)
    }
    
    func filteredFetchTriggerEmitter() -> Observable<FilteredFetchData> {
        return filteredFetchTriggerSubject
    }
    
    func locationProcessingEmitter() -> Observable<Bool> {
        return locationProcessingSubject
    }
    
    func joinEventEmitter() -> Observable<JoinEventData> {
        return joinEventSubject
    }
}
