//
//  ChatContract.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

protocol ChatView {
    
    func newMessagesListenerToggleEmitter() -> Observable<Bool>
    
    func batchFetchTriggerEmitter() -> Observable<String>
    
    func messageEmitter() -> Observable<String>
    
    func render(chatViewState: ChatViewState)
}

protocol ChatInteractor {
    
    func listenForNewMessages(eventId: String) -> Observable<PartialChatViewState>
    
    func stopListeningForNewMessages(eventId: String) -> Observable<PartialChatViewState>
    
    func fetchChatMessagesBatch(eventId: String, fromTimestamp: String) -> Observable<PartialChatViewState>
    
    func sendMessage(message: String, eventId: String, messageId: String) -> Observable<PartialChatViewState>
}

protocol ChatService {
    
    var userId: String { get }
    
    func listenForNewMessages(eventId: String) -> Observable<RawMessage>
    
    func stopListeningForNewMessages(eventId: String) -> Observable<Bool>
    
    func fetchMessagesBatch(eventId: String, fromTimestamp: String) -> Observable<[RawMessage]>
    
    func sendMessage(rawMessage: RawMessage, eventId: String)
}
