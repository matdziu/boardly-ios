//
//  ChatInteractorTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import Nimble
import RxSwift

class ChatInteractorTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let testRawMessage = RawMessage(id: "testMessageId", text: "testMessage", senderId: "testSenderId")
        let testMessagesBatch = [
            RawMessage(id: "1", text: "one", senderId: "first", timestamp: "2018-08-24T07:06:18.004Z"),
            RawMessage(id: "2", text: "two", senderId: "second", timestamp:"2018-08-24T07:06:20.004Z")]
        let initialMessagesList = [Message(id: "initial", text: "initial text", isSent: true, type: .sent)]
        var chatInteractor: ChatInteractor!
        
        beforeEach {
            chatInteractor = ChatInteractorImpl(chatService:
                MockChatService(userId: "testSenderId",
                                listenForNewMessages: Observable.just(testRawMessage),
                                stopListeningForNewMessages: Observable.just(true),
                                fetchMessagesBatch: Observable.just(testMessagesBatch)), initialMessagesList: initialMessagesList)
        }
        
        describe("ChatInteractor") {
            
            it("test message arrival") {
                let output = try! chatInteractor.listenForNewMessages(eventId: "testEventId")
                    .toBlocking()
                    .toArray()
                expect(output).to(equal([PartialChatViewState.messagesListChanged(newMessagesList: [
                    Message(id: "initial", text: "initial text", isSent: true, type: .sent),
                    Message(id: "testMessageId", text: "testMessage", isSent: true, type: .sent)])]))
            }
            
            it("test removing new messages listener") {
                let output = try! chatInteractor.stopListeningForNewMessages(eventId: "testEventId")
                    .toBlocking()
                    .toArray()
                expect(output).to(equal([PartialChatViewState.newMessagesListenerRemoved]))
            }
            
            it("test successful message sending") {
                let output = try! chatInteractor.sendMessage(message: "this is a test message", eventId: "testEventId", messageId: "testMessageId")
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialChatViewState.messagesListChanged(newMessagesList: [
                    Message(id: "initial", text: "initial text", isSent: true, type: .sent),
                    Message(id: "testMessageId", text: "this is a test message", isSent: false, type: .sent)])]))
            }
            
            it("test chat message batch arrival") {
                let output = try! chatInteractor.fetchChatMessagesBatch(eventId: "testEventId", fromTimestamp: "2018-04-24")
                    .toBlocking()
                    .toArray()
                
                expect(output).to(equal([PartialChatViewState.messagesListChanged(newMessagesList: [
                    Message(id: "1", text: "one", isSent: true, senderName: "", senderImageUrl: "", timestamp: "2018-08-24T07:06:18.004Z", type: .received),
                    Message(id: "2", text: "two", isSent: true, senderName: "", senderImageUrl: "", timestamp: "2018-08-24T07:06:20.004Z", type: .received),
                    Message(id: "initial", text: "initial text", isSent: true, type: .sent)])]))
            }
        }
    }
}
