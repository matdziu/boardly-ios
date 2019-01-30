//
//  ChatPresenterTest.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Quick
import RxSwift

class ChatPresenterTest: QuickSpec {
    
    override func spec() {
        super.spec()
        
        let testMessage = Message(id: "test message", text: "this is a test message", type: .sent)
        let testMessagesBatch = [
            Message(id: "1", text: "one", isSent: true, timestamp: "2018-08-24T07:06:18.004Z", type: .sent),
            Message(id: "2", text: "two",  isSent: true, timestamp:"2018-08-24T07:06:20.004Z", type: .received)]
        var chatViewRobot: ChatViewRobot!
        var mockChatInteractor: MockChatInteractor!
        
        beforeEach {
            mockChatInteractor = MockChatInteractor(
                listenForNewMessages: Observable.just(PartialChatViewState.messagesListChanged(newMessagesList: [testMessage])),
                stopListeningForNewMessages: Observable.just(PartialChatViewState.newMessagesListenerRemoved),
                fetchChatMessagesBatch: Observable.just(PartialChatViewState.messagesListChanged(newMessagesList: testMessagesBatch)),
                sendMessage:  Observable.just(PartialChatViewState.messagesListChanged(newMessagesList: [testMessage])))
            chatViewRobot = ChatViewRobot(chatViewPresenter: ChatPresenter(chatInteractor: mockChatInteractor))
        }
        
        describe("ChatPresenter") {
            
            it("when new message arrives, it is added to messages list in view state") {
                chatViewRobot.toggleMessagesListening(toggle: true)
                chatViewRobot.assert(expectedViewStates: [
                    ChatViewState(),
                    ChatViewState(progress: false,
                                  messagesList: [testMessage])])
            }
            
            it("when new messages listener is detached, view state does not change") {
                chatViewRobot.toggleMessagesListening(toggle: false)
                chatViewRobot.assert(expectedViewStates: [
                    ChatViewState(),
                    ChatViewState()])
            }
            
            it("when new message is sent, it is added to messages list in view state") {
                chatViewRobot.sendMessage(message: "this is a test message     ")
                chatViewRobot.assert(expectedViewStates: [
                    ChatViewState(),
                    ChatViewState(progress: false,
                                  messagesList: [testMessage])])
                mockChatInteractor.verifySendMessage(message: "this is a test message", eventId: "testEventId", messageId: "", times: 1)
            }
            
            it("when batch is fetched, it is added to messages list in view state") {
                chatViewRobot.triggerBatchFetching(fromTimestamp: "28-04-2019")
                chatViewRobot.assert(expectedViewStates: [
                    ChatViewState(),
                    ChatViewState(progress: false,
                                  messagesList: testMessagesBatch)])
            }
        }
    }
}
