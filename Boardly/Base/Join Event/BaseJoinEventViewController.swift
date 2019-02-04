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
    
    func showJoinEventViewController(completionHandler: @escaping (String) -> Void) {
        guard let joinEventViewController = storyboard?.instantiateViewController(withIdentifier: JOIN_EVENT_VIEW_CONTROLLER_ID)
            as? JoinEventViewController else { return }
        joinEventViewController.providesPresentationContextTransitionStyle = true
        joinEventViewController.definesPresentationContext = true
        joinEventViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        joinEventViewController.completionHandler = completionHandler
        present(joinEventViewController, animated: true, completion: nil)
    }
    
    func emitJoinEventData(joinEventData: JoinEventData) {
        joinEventSubject.onNext(joinEventData)
    }
    
    func joinEvent(eventId: String) {
        showJoinEventViewController { helloText in
            let joinEventData = JoinEventData(eventId: eventId, helloText: helloText)
            self.emitJoinEventData(joinEventData: joinEventData)
            self.showAlert(message: "Join request sent")
        }
    }
}
