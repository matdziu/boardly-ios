//
//  EventServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 12/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation
import FirebaseFunctions

class EventServiceImpl: BaseServiceImpl, EventService {
    
    private lazy var functions = Functions.functions()
    
    func addEvent(inputData: EventInputData) -> Observable<Bool> {
        var inputData = inputData
        inputData.adminId = getCurrentUserId()
        
        let eventKey = database.reference().childByAutoId().key ?? UUID().uuidString
        let location = CLLocation(latitude: inputData.placeLatitude, longitude: inputData.placeLongitude)
        
        return setGeoLocation(eventKey: eventKey, location: location)
            .flatMap { [unowned self] _ in
                return self.addEventData(eventKey: eventKey, inputData: inputData)
            }.map { _ in return true }
    }
    
    func editEvent(inputData: EventInputData) -> Observable<Bool> {
        let location = CLLocation(latitude: inputData.placeLatitude, longitude: inputData.placeLongitude)
        
        return setGeoLocation(eventKey: inputData.eventId, location: location)
            .flatMap { [unowned self] _ in
                return self.editEventData(eventKey: inputData.eventId, inputData: inputData)
            }.map { _ in return true }
    }
    
    func deleteEvent(eventId: String) -> Observable<Bool> {
        let resultSubject = PublishSubject<Bool>()
        functions.httpsCallable(DELETE_EVENT_FUNCTION).call([EVENT_ID_CHILD: eventId]) { (result, error) in
            if let error = error as NSError? {
                resultSubject.onError(error)
            }
            if let responseCode = result?.data as? Int {
                if responseCode == 200 {
                    resultSubject.onNext(true)
                }
            }
        }
        return resultSubject
    }
    
    private func setGeoLocation(eventKey: String, location: CLLocation) -> Observable<Bool> {
        let resultSubject = PublishSubject<Bool>()
        getGeoFire(childPath: EVENTS_NODE).setLocation(location, forKey: eventKey) { error in
            if error == nil {
                resultSubject.onNext(true)
            } else {
                resultSubject.onError(error!)
            }
        }
        return resultSubject
    }
    
    private func editEventData(eventKey: String, inputData: EventInputData) -> Observable<Bool> {
        let resultSubject = PublishSubject<Bool>()
        getSingleEventNodeRef(eventId: eventKey).updateChildValues(inputData.toDict()) { error, _ in
            if error == nil {
                resultSubject.onNext(true)
            } else {
                resultSubject.onError(error!)
            }
        }
        return resultSubject
    }
    
    private func addEventData(eventKey: String, inputData: EventInputData) -> Observable<Bool> {
        let resultSubject = PublishSubject<Bool>()
        getUserCreatedEventsNodeRef(userId: getCurrentUserId())
            .childByAutoId()
            .setValue(eventKey) { error, _ in
                if error == nil {
                    resultSubject.onNext(true)
                } else {
                    resultSubject.onError(error!)
                }
        }
        return Observable.zip([editEventData(eventKey: eventKey, inputData: inputData), resultSubject]).map { _ in return true }
    }
}
