//
//  MockPickGameView.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 08/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockPickPlaceView: PickPlaceView {
    
    var renderedStates: [PickPlaceViewState] = []
    let querySubject = PublishSubject<String>()
    
    func render(pickPlaceViewState: PickPlaceViewState) {
        renderedStates.append(pickPlaceViewState)
    }
    
    func queryEmitter() -> Observable<String> {
        return querySubject
    }
}

