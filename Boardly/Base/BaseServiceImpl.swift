//
//  BaseServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 24/12/2018.
//  Copyright © 2018 Mateusz Dziubek. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import GeoFire
import RxSwift

class BaseServiceImpl {
    
    let database = Database.database()
    let storage = Storage.storage()
    
    func getUserNodeRef(userId: String) -> DatabaseReference {
        return database.reference(withPath: "\(USERS_NODE)/\(userId)")
    }
    
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    func getCurrentUserId() -> String {
        return getCurrentUser()?.uid ?? ""
    }
    
    func getStorageProfilePictureRef(userId: String) -> StorageReference {
        return storage.reference().child(userId)
    }
    
    func getGeoFire(childPath: String) -> GeoFire {
        return GeoFire(firebaseRef: database.reference(withPath: childPath))
    }
    
    func getSingleEventNodeRef(eventId: String) -> DatabaseReference {
        return database.reference(withPath: "\(EVENTS_NODE)/\(eventId)")
    }
    
    func getUserCreatedEventsNodeRef(userId: String) -> DatabaseReference {
        return database.reference(withPath: "\(USERS_NODE)/\(userId)/\(EVENTS_NODE)/\(CREATED_EVENTS_NODE)")
    }
    
    func getUserPendingEventsNodeRef(userId: String) -> DatabaseReference {
        return database.reference(withPath: "\(USERS_NODE)/\(userId)/\(EVENTS_NODE)/\(PENDING_EVENTS_NODE)")
    }
    
    func getUserAcceptedEventsNodeRef(userId: String) -> DatabaseReference {
        return database.reference(withPath: "\(USERS_NODE)/\(userId)/\(EVENTS_NODE)/\(ACCEPTED_EVENTS_NODE)")
    }
    
    func getUserNotifySettingsRef(userId: String) -> DatabaseReference {
        return database.reference(withPath: "\(NOTIFY_SETTINGS_NODE)/\(userId)")
    }
    
    func getPendingPlayersNode(eventId: String) -> DatabaseReference {
        return database.reference(withPath: "\(PLAYERS_NODE)/\(eventId)/\(PENDING_EVENTS_NODE)")
    }
    
    func acceptedEventIdsList() -> Observable<[String]> {
        return idsList(idsDatabaseReference: getUserAcceptedEventsNodeRef(userId: getCurrentUserId()))
    }
    
    func createdEventIdsList() -> Observable<[String]> {
        return idsList(idsDatabaseReference: getUserCreatedEventsNodeRef(userId: getCurrentUserId()))
    }
    
    func pendingEventIdsList() -> Observable<[String]> {
        return idsList(idsDatabaseReference: getUserPendingEventsNodeRef(userId: getCurrentUserId()))
    }
    
    func idsList(idsDatabaseReference: DatabaseReference) -> Observable<[String]> {
        let resultSubject = PublishSubject<[String]>()
        
        idsDatabaseReference.observeSingleEvent(of: .value) { snapshot in
            var idsList: [String] = []
            for childSnapshot in snapshot.children {
                let value = (childSnapshot as? DataSnapshot)?.value as? String ?? ""
                idsList.append(value)
            }
            resultSubject.onNext(idsList)
        }
        
        return resultSubject
    }
    
    func events(idsList: [String]) -> Observable<[BoardlyEvent]> {
        let resultSubject = PublishSubject<[BoardlyEvent]>()
        var eventsList: [BoardlyEvent] = []
        
        if idsList.isEmpty {
            return Observable.just(eventsList)
        }
        
        for id in idsList {
            getSingleEventNodeRef(eventId: id).observeSingleEvent(of: .value) { snapshot in
                eventsList.append(BoardlyEvent(snapshot: snapshot))
                if eventsList.count == idsList.count {
                    resultSubject.onNext(eventsList)
                }
            }
        }
        
        return resultSubject
    }
    
    func sendJoinRequest(joinEventData: JoinEventData) -> Observable<Bool> {
        return Observable.zip(sendToPendingEvents(eventId: joinEventData.eventId), sendToPendingPlayers(joinEventData: joinEventData)) { _,_ in
            return true
        }
    }
    
    private func sendToPendingEvents(eventId: String) -> Observable<Bool> {
        let resultSubject = PublishSubject<Bool>()
        getUserPendingEventsNodeRef(userId: getCurrentUserId())
            .childByAutoId()
            .setValue(eventId) { (error, _) in
                if error == nil {
                    resultSubject.onNext(true)
                } else {
                    resultSubject.onError(error!)
                }
        }
        return resultSubject
    }
    
    private func sendToPendingPlayers(joinEventData: JoinEventData) -> Observable<Bool> {
        let resultSubject = PublishSubject<Bool>()
        getPendingPlayersNode(eventId: joinEventData.eventId)
            .child(getCurrentUserId())
            .setValue(joinEventData.helloText) { (error, _) in
                if error == nil {
                    resultSubject.onNext(true)
                } else {
                    resultSubject.onError(error!)
                }
        }
        return resultSubject
    }
}
