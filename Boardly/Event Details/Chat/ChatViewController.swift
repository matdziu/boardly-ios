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
    
    private let chatPresenter = ChatPresenter(chatInteractor: ChatInteractorImpl(chatService: ChatServiceImpl(), initialMessagesList: []))
    private var newMessagesListenerToggleSubject: PublishSubject<Bool>!
    private var batchFetchTriggerSubject: PublishSubject<String>!
    
    var eventId = ""
    
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
        return Observable.empty()
    }
    
    func render(chatViewState: ChatViewState) {
        
    }
}
