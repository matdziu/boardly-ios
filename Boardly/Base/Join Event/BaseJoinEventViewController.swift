//
//  BaseJoinEventViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 24/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class BaseJoinEventViewController: UIViewController, BaseJoinEventView {
    
    var joinEventSubject = PublishSubject<JoinEventData>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        joinEventSubject = PublishSubject()
    }
    
    func joinEventEmitter() -> Observable<JoinEventData> {
        return joinEventSubject
    }
}
