//
//  ChatViewRobot.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import Nimble

class ChatViewRobot {
    
    private let mockChatView = MockChatView()
    
    init(chatViewPresenter: ChatPresenter) {
        chatViewPresenter.bind(chatView: mockChatView, eventId: "testEventId")
    }
    
    func toggleMessagesListening(toggle: Bool) {
        mockChatView.newMessagesListenerToggleSubject.onNext(toggle)
    }
    
    func triggerBatchFetching(fromTimestamp: String) {
        mockChatView.batchFetchTriggerSubject.onNext(fromTimestamp)
    }
    
    func sendMessage(message: String) {
        mockChatView.messageSubject.onNext(message)
    }
    
    func assert(expectedViewStates: [ChatViewState]) {
        expect(self.mockChatView.renderedStates).to(equal(expectedViewStates))
    }
}
