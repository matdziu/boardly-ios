//
//  MockChatView.swift
//  BoardlyTests
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

@testable import Boardly
import Foundation
import RxSwift

class MockChatView: ChatView {
    
    var renderedStates: [ChatViewState] = []
    let newMessagesListenerToggleSubject = PublishSubject<Bool>()
    let batchFetchTriggerSubject = PublishSubject<String>()
    let messageSubject = PublishSubject<String>()
    
    func newMessagesListenerToggleEmitter() -> Observable<Bool> {
        return newMessagesListenerToggleSubject
    }
    
    func batchFetchTriggerEmitter() -> Observable<String> {
        return batchFetchTriggerSubject
    }
    
    func messageEmitter() -> Observable<String> {
        return messageSubject
    }
    
    func render(chatViewState: ChatViewState) {
        renderedStates.append(chatViewState)
    }
}

