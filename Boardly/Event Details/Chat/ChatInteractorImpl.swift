//
//  ChatInteractorImpl.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class ChatInteractorImpl: ChatInteractor {
    
    private let chatService: ChatService
    private var currentMessagesList: [Message]
    
    init(chatService: ChatService,
         initialMessagesList: [Message]) {
        self.chatService = chatService
        self.currentMessagesList = initialMessagesList
    }
    
    func listenForNewMessages(eventId: String) -> Observable<PartialChatViewState> {
        return chatService.listenForNewMessages(eventId: eventId)
            .map { $0.toMessage(currentUserId: self.chatService.userId) }
            .do(onNext: { newMessage in
                self.currentMessagesList = self.currentMessagesList.filter { $0.id != newMessage.id } + [newMessage]
            })
            .map { _ in PartialChatViewState.messagesListChanged(newMessagesList: self.currentMessagesList) }
    }
    
    func stopListeningForNewMessages(eventId: String) -> Observable<PartialChatViewState> {
        return chatService.stopListeningForNewMessages(eventId: eventId)
            .map { _ in PartialChatViewState.newMessagesListenerRemoved }
    }
    
    func fetchChatMessagesBatch(eventId: String, fromTimestamp: String) -> Observable<PartialChatViewState> {
        return chatService.fetchMessagesBatch(eventId: eventId, fromTimestamp: fromTimestamp)
            .map { $0.map { $0.toMessage(currentUserId: self.chatService.userId) } }
            .do(onNext: { messagesBatchList in
                self.currentMessagesList = (messagesBatchList.sorted(by: { $0.timestamp < $1.timestamp }) + self.currentMessagesList)
                    .distinct { $0.id }
            })
            .map { _ in PartialChatViewState.messagesListChanged(newMessagesList: self.currentMessagesList) }
    }
    
    func sendMessage(message: String, eventId: String, messageId: String = "") -> Observable<PartialChatViewState> {
        let rawMessage = RawMessage(id: checkMessageId(messageId: messageId),
                                    text: message,
                                    senderId: chatService.userId)
        chatService.sendMessage(rawMessage: rawMessage, eventId: eventId)
        currentMessagesList = currentMessagesList + [rawMessage.toMessage(currentUserId: chatService.userId, isSent: false)]
        return Observable.just(PartialChatViewState.messagesListChanged(newMessagesList: currentMessagesList))
    }
    
    private func checkMessageId(messageId: String) -> String {
        if messageId.isEmpty {
            return UUID().uuidString
        } else {
            return messageId
        }
    }
}
