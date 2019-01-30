//
//  MockChatInteractor.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift
import Nimble

class MockChatInteractor: ChatInteractor {
    
    private var listenForNewMessagesResult = Observable<PartialChatViewState>.empty()
    private var stopListeningForNewMessagesResult = Observable<PartialChatViewState>.empty()
    private var fetchChatMessagesBatchResult = Observable<PartialChatViewState>.empty()
    private var sendMessageResult = Observable<PartialChatViewState>.empty()
    private var sendMessageCall = SendMessageCall()
    
    init(listenForNewMessages: Observable<PartialChatViewState> = Observable.empty(),
         stopListeningForNewMessages: Observable<PartialChatViewState> = Observable.empty(),
         fetchChatMessagesBatch: Observable<PartialChatViewState> = Observable.empty(),
         sendMessage: Observable<PartialChatViewState> = Observable.empty()) {
        self.listenForNewMessagesResult = listenForNewMessages
        self.stopListeningForNewMessagesResult = stopListeningForNewMessages
        self.fetchChatMessagesBatchResult = fetchChatMessagesBatch
        self.sendMessageResult = sendMessage
    }
    
    func listenForNewMessages(eventId: String) -> Observable<PartialChatViewState> {
        return listenForNewMessagesResult
    }
    
    func stopListeningForNewMessages(eventId: String) -> Observable<PartialChatViewState> {
        return stopListeningForNewMessagesResult
    }
    
    func fetchChatMessagesBatch(eventId: String, fromTimestamp: String) -> Observable<PartialChatViewState> {
        return fetchChatMessagesBatchResult
    }
    
    func sendMessage(message: String, eventId: String, messageId: String) -> Observable<PartialChatViewState> {
        sendMessageCall.message = message
        sendMessageCall.eventId = eventId
        sendMessageCall.messageId = messageId
        sendMessageCall.times = sendMessageCall.times + 1
        return sendMessageResult
    }
    
    func verifySendMessage(message: String, eventId: String, messageId: String, times: Int) {
        expect(self.sendMessageCall).to(equal(SendMessageCall(
            message: message,
            eventId: eventId,
            messageId: messageId,
            times: times)))
    }
}

struct SendMessageCall: Equatable {
    var message: String? = nil
    var eventId: String? = nil
    var messageId: String? = nil
    var times: Int = 0
}
