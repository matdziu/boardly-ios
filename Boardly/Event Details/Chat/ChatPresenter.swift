//
//  ChatPresenter.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import RxSwift

class ChatPresenter {
    
    private let chatInteractor: ChatInteractor
    private var disposeBag = DisposeBag()
    private let stateSubject: BehaviorSubject<ChatViewState>
    
    init(chatInteractor: ChatInteractor,
         initialViewState: ChatViewState = ChatViewState()) {
        self.chatInteractor = chatInteractor
        self.stateSubject = BehaviorSubject(value: initialViewState)
    }
    
    func bind(chatView: ChatView, eventId: String) {
        let newMessagesListenerToggleObservable = chatView.newMessagesListenerToggleEmitter()
            .flatMap { toggle -> Observable<PartialChatViewState> in
                if toggle {
                    return self.chatInteractor.listenForNewMessages(eventId: eventId)
                } else {
                    return self.chatInteractor.stopListeningForNewMessages(eventId: eventId)
                }
        }
        
        let batchFetchTriggerObservable = chatView.batchFetchTriggerEmitter().flatMap {
            self.chatInteractor.fetchChatMessagesBatch(eventId: eventId, fromTimestamp: $0)
        }
        
        let messageObservable = chatView.messageEmitter()
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .flatMap { self.chatInteractor.sendMessage(message: $0, eventId: eventId, messageId: "") }
        
        Observable
            .merge([newMessagesListenerToggleObservable,
                    batchFetchTriggerObservable,
                    messageObservable])
            .scan(try! stateSubject.value()) { (viewState: ChatViewState, partialState: PartialChatViewState) -> ChatViewState in
                return self.reduce(previousState: viewState, partialState: partialState)
            }
            .observeOn(MainScheduler.instance)
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
        
        stateSubject
            .subscribe(onNext: {(viewState: ChatViewState) in
                chatView.render(chatViewState: viewState)
            })
            .disposed(by: disposeBag)
    }
    
    private func reduce(previousState: ChatViewState, partialState: PartialChatViewState) -> ChatViewState {
        return partialState.reduce(previousState: previousState)
    }
    
    func unbind() {
        disposeBag = DisposeBag()
    }
}
