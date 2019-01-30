//
//  MockChatService.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockChatService: ChatService {
    
    private var userIdResult: String = ""
    private var listenForNewMessagesResult = Observable<RawMessage>.empty()
    private var stopListeningForNewMessagesResult = Observable<Bool>.empty()
    private var fetchMessagesBatchResult = Observable<[RawMessage]>.empty()
    
    init(userId: String = "",
         listenForNewMessages: Observable<RawMessage> = Observable.empty(),
         stopListeningForNewMessages: Observable<Bool> = Observable.empty(),
         fetchMessagesBatch: Observable<[RawMessage]> = Observable.empty()) {
        self.userIdResult = userId
        self.listenForNewMessagesResult = listenForNewMessages
        self.stopListeningForNewMessagesResult = stopListeningForNewMessages
        self.fetchMessagesBatchResult = fetchMessagesBatch
    }
    
    var userId: String {
        get {
            return userIdResult
        }
    }
    
    func listenForNewMessages(eventId: String) -> Observable<RawMessage> {
        return listenForNewMessagesResult
    }
    
    func stopListeningForNewMessages(eventId: String) -> Observable<Bool> {
        return stopListeningForNewMessagesResult
    }
    
    func fetchMessagesBatch(eventId: String, fromTimestamp: String) -> Observable<[RawMessage]> {
        return fetchMessagesBatchResult
    }
    
    func sendMessage(rawMessage: RawMessage, eventId: String) {
        
    }
}
