//
//  ChatServiceImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 01/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseDatabase

class ChatServiceImpl: BaseServiceImpl, ChatService {
    
    private let batchSize: UInt = 10
    
    var userId: String {
        get {
            return getCurrentUserId()
        }
    }
    
    func listenForNewMessages(eventId: String) -> Observable<RawMessage> {
        return newMessageAdded(eventId: eventId)
            .flatMap { self.completeSingleRawMessage(partialMessage: $0) }
    }
    
    private func newMessageAdded(eventId: String) -> Observable<RawMessage> {
        let resultSubject = PublishSubject<RawMessage>()
        
        getChatNodeReference(eventId: eventId).observe(.childAdded) { snapshot in
            let rawMessage = RawMessage(snapshot: snapshot)
            resultSubject.onNext(rawMessage)
        }
        
        return resultSubject
    }
    
    private func completeRawMessages(partialMessagesList: [RawMessage]) -> Observable<[RawMessage]> {
        return Observable
            .from(partialMessagesList)
            .flatMap { self.completeSingleRawMessage(partialMessage: $0) }
            .toArray()
    }
    
    private func completeSingleRawMessage(partialMessage: RawMessage) -> Single<RawMessage> {
        let resultSubject = PublishSubject<RawMessage>()
        var modifiedMessage = partialMessage
        getUserNodeRef(userId: partialMessage.senderId).observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? [String : Any] ?? [:]
            let name = value[NAME_CHILD] as? String ?? ""
            let profilePictureUrl = value[PROFILE_PICTURE_CHILD] as? String ?? ""
            modifiedMessage.senderName = name
            modifiedMessage.senderImageUrl = profilePictureUrl
            resultSubject.onNext(modifiedMessage)
        }
        return resultSubject.asSingle()
    }
    
    func stopListeningForNewMessages(eventId: String) -> Observable<Bool> {
        getChatNodeReference(eventId: eventId).removeAllObservers()
        return Observable.just(true)
    }
    
    func fetchMessagesBatch(eventId: String, fromTimestamp: String) -> Observable<[RawMessage]> {
        return fetchPartialMessagesBatch(eventId: eventId, fromTimestamp: fromTimestamp)
            .flatMap { self.completeRawMessages(partialMessagesList: $0) }
    }
    
    private func fetchPartialMessagesBatch(eventId: String, fromTimestamp: String) -> Observable<[RawMessage]> {
        let resultSubject = PublishSubject<[RawMessage]>()
        
        getChatNodeReference(eventId: eventId)
            .queryOrdered(byChild: TIMESTAMP_CHILD)
            .queryEnding(atValue: fromTimestamp)
            .queryLimited(toLast: batchSize)
            .observeSingleEvent(of: .value) { snapshot in
                var messagesBatchList: [RawMessage] = []
                for case let messageSnapshot as DataSnapshot in snapshot.children {
                    let rawMessage = RawMessage(snapshot: messageSnapshot)
                    messagesBatchList.append(rawMessage)
                }
                resultSubject.onNext(messagesBatchList)
        }
        
        return resultSubject
    }
    
    func sendMessage(rawMessage: RawMessage, eventId: String) {
        getChatNodeReference(eventId: eventId).childByAutoId().setValue(rawMessage.toDict())
    }
}
