//
//  ChildEventDetailsViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 05/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ChildEventDetailsViewController: UIViewController, EventDetailsView {
    
    private var ratingEventSubject: PublishSubject<RateInput>!
    var eventId: String = ""
    var isAdmin = false
    
    func prepare(eventId: String, isAdmin: Bool) {
        self.eventId = eventId
        self.isAdmin = isAdmin
    }
    
    func initEmitters() {
        ratingEventSubject = PublishSubject()
    }
    
    func ratingEmitter() -> Observable<RateInput> {
        return ratingEventSubject
    }
    
    func emitRating(rateInput: RateInput) {
        ratingEventSubject.onNext(rateInput)
    }
}
