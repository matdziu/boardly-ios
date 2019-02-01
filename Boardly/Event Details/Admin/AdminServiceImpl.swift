//
//  AdminServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 01/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseDatabase

class AdminServiceImpl: EventDetailsServiceImpl, AdminService {
    
    func getAcceptedPlayers(eventId: String) -> Observable<[Player]> {
        return getPartialPlayersProfiles(databaseReference: getAcceptedPlayersNode(eventId: eventId))
            .flatMap { self.completePlayerProfilesWithRating(partialPlayersList: $0, eventId: eventId) }
    }
    
    func getPendingPlayers(eventId: String) -> Observable<[Player]> {
        return getPartialPlayersProfiles(databaseReference: getPendingPlayersNode(eventId: eventId))
            .flatMap { self.completePlayerProfiles(partialPlayersList: $0) }
    }
    
    func acceptPlayer(eventId: String, playerId: String) -> Observable<Bool> {
        return deleteNodesTask(userEventsNode: getUserPendingEventsNodeRef(userId: playerId),
                        eventUsersNode: getPendingPlayersNode(eventId: eventId),
                        eventId: eventId,
                        userId: playerId)
            .flatMap {
                self.moveNodesTask(helloText: $0,
                              userEventsNode: self.getUserAcceptedEventsNodeRef(userId: playerId),
                              eventUsersNode: self.getAcceptedPlayersNode(eventId: eventId),
                              playerId: playerId,
                              eventId: eventId)
        }
    }
    
    func kickPlayer(eventId: String, playerId: String) -> Observable<Bool> {
        return removePlayer(eventId: eventId, playerId: playerId)
    }
    
    private func moveNodesTask(helloText: String,
                               userEventsNode: DatabaseReference,
                               eventUsersNode: DatabaseReference,
                               playerId: String,
                               eventId: String) -> Observable<Bool> {
        return Observable.zip(moveUserEventsNode(userEventsNode: userEventsNode, eventId: eventId),
                              moveEventUsersNode(eventUsersNode: eventUsersNode, playerId: playerId, helloText: helloText)) { _,_ in
                                return true
        }
    }
    
    private func moveUserEventsNode(userEventsNode: DatabaseReference,
                                    eventId: String) -> Observable<Bool> {
        let resultSubject = PublishSubject<Bool>()
        
        userEventsNode.childByAutoId().setValue(eventId) { (error, _) in
            if error == nil {
                resultSubject.onNext(true)
            }
        }
        
        return resultSubject
    }
    
    private func moveEventUsersNode(eventUsersNode: DatabaseReference,
                                    playerId: String,
                                    helloText: String) -> Observable<Bool> {
        let resultSubject = PublishSubject<Bool>()
        
        eventUsersNode.child(playerId).setValue(helloText) { (error, _) in
            if error == nil {
                resultSubject.onNext(true)
            }
        }
        
        return resultSubject
    }
}
