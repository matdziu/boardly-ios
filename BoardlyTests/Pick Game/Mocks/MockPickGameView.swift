//
//  MockPickGameView.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 31/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockPickGameView: PickGameView {
    
    var renderedStates: [PickGameViewState] = []
    let querySubject = PublishSubject<String>()
    
    func render(pickGameViewState: PickGameViewState) {
        renderedStates.append(pickGameViewState)
    }
    
    func queryEmitter() -> Observable<String> {
        return querySubject
    }
}
