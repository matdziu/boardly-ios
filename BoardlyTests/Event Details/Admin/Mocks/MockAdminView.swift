//
//  MockAdminView.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 31/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockAdminView: AdminView {
    
    var renderedStates: [AdminViewState] = []
    let fetchEventDetailsTriggerSubject = PublishSubject<Bool>()
    let kickPlayerSubject = PublishSubject<String>()
    let acceptPlayerSubject = PublishSubject<String>()
    let ratingSubject = PublishSubject<RateInput>()
    
    func render(adminViewState: AdminViewState) {
        renderedStates.append(adminViewState)
    }
    
    func fetchEventDetailsTriggerEmitter() -> Observable<Bool> {
        return fetchEventDetailsTriggerSubject
    }
    
    func kickPlayerEmitter() -> Observable<String> {
        return kickPlayerSubject
    }
    
    func acceptPlayerEmitter() -> Observable<String> {
        return acceptPlayerSubject
    }
    
    func ratingEmitter() -> Observable<RateInput> {
        return ratingSubject
    }
    
    func emitRating(rateInput: RateInput) {
        ratingSubject.onNext(rateInput)
    }
}
