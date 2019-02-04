//
//  ChatViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 01/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ChatViewController: UIViewController, ChatView {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextView: BoardlyTextView!
    
    private let chatPresenter = ChatPresenter(chatInteractor: ChatInteractorImpl(chatService: ChatServiceImpl(), initialMessagesList: []))
    private var newMessagesListenerToggleSubject: PublishSubject<Bool>!
    private var batchFetchTriggerSubject: PublishSubject<String>!
    
    var eventId = ""
    
    private var messages: [Message] = [] {
        didSet {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        chatPresenter.bind(chatView: self, eventId: eventId)
    }
    
    private func initEmitters() {
        newMessagesListenerToggleSubject = PublishSubject()
        batchFetchTriggerSubject = PublishSubject()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        chatPresenter.unbind()
        super.viewWillDisappear(animated)
    }
    
    func newMessagesListenerToggleEmitter() -> Observable<Bool> {
        return newMessagesListenerToggleSubject
    }
    
    func batchFetchTriggerEmitter() -> Observable<String> {
        return batchFetchTriggerSubject
    }
    
    func messageEmitter() -> Observable<String> {
        return sendButton.rx.tap.map { return self.messageTextView.text }
            .do(onNext: { _ in self.messageTextView.text = "" })
    }
    
    func render(chatViewState: ChatViewState) {
        showProgress(show: chatViewState.progress)
        showIncentiveText(show: chatViewState.messagesList.isEmpty && !chatViewState.progress)
        messages = chatViewState.messagesList
    }
    
    private func showProgress(show: Bool) {
        
    }
    
    private func showIncentiveText(show: Bool) {
        
    }
}
