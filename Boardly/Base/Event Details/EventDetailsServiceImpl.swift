//
//  EventDetailsServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 01/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseDatabase

class EventDetailsServiceImpl: BaseServiceImpl, EventDetailsService {
    
    func sendRating(rateInput: RateInput) -> Observable<Bool> {
        let resultSubject = PublishSubject<Bool>()
        
        getUserRatingHashesRef(userId: rateInput.playerId)
            .child("\(rateInput.eventId)\(getCurrentUserId())")
            .setValue(rateInput.rating) { (error, _) in
                if error == nil {
                    resultSubject.onNext(true)
                }
        }
        
        return resultSubject
    }
    
    func fetchEventDetails(eventId: String) -> Observable<BoardlyEvent> {
        let resultSubject = PublishSubject<BoardlyEvent>()
        
        getSingleEventNodeRef(eventId: eventId).observe(.value) { snapshot in
            let event = BoardlyEvent(snapshot: snapshot)
            resultSubject.onNext(event)
        }
        
        return resultSubject
    }
    
    func removePlayer(eventId: String, playerId: String) -> Observable<Bool> {
        return deleteNodesTask(userEventsNode: getUserAcceptedEventsNodeRef(userId: playerId),
                               eventUsersNode: getAcceptedPlayersNode(eventId: eventId),
                               eventId: eventId,
                               userId: playerId)
            .map { _ in true }
    }
    
    func deleteNodesTask(userEventsNode: DatabaseReference,
                         eventUsersNode: DatabaseReference,
                         eventId: String,
                         userId: String) -> Observable<String> {
        return Observable.zip(
            deleteEventFromUsersNodeTask(userEventsNode: userEventsNode, eventId: eventId),
            deleteUserFromEventsNodeTask(eventUsersNode: eventUsersNode, userId: userId)) {
                _, helloText in return helloText
        }
    }
    
    private func deleteEventFromUsersNodeTask(userEventsNode: DatabaseReference,
                                              eventId: String) -> Observable<Bool> {
        let resultSubject = PublishSubject<Bool>()
        
        userEventsNode
            .queryOrderedByValue()
            .queryEqual(toValue: eventId)
            .observeSingleEvent(of: .value) { snapshot in
                for case let childSnapshot as DataSnapshot in snapshot.children {
                    childSnapshot.ref.removeValue(completionBlock: { error, _ in
                        if error == nil {
                            resultSubject.onNext(true)
                        }
                    })
                }
        }
        
        return resultSubject
    }
    
    private func deleteUserFromEventsNodeTask(eventUsersNode: DatabaseReference,
                                              userId: String) -> Observable<String> {
        let resultSubject = PublishSubject<String>()
        
        eventUsersNode
            .child(userId)
            .observeSingleEvent(of: .value) { snapshot in
                let helloText = snapshot.value as? String ?? ""
                snapshot.ref.removeValue(completionBlock: { error, _ in
                    if error == nil {
                        resultSubject.onNext(helloText)
                    }
                })
        }
        
        return resultSubject
    }
}
