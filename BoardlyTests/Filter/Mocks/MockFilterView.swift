//
//  MockFilterView.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 30/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockFilterView: FilterView {
    
    var renderedStates: [FilterViewState] = []
    let gameIdSubject = PublishSubject<String>()
    let locationProcessingSubject = PublishSubject<Bool>()
    
    func gameIdEmitter() -> Observable<String> {
        return gameIdSubject
    }
    
    func locationProcessingEmitter() -> Observable<Bool> {
        return locationProcessingSubject
    }
    
    func render(filterViewState: FilterViewState) {
        renderedStates.append(filterViewState)
    }
}
