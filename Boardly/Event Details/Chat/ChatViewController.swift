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
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    @IBOutlet weak var hintLabel: UILabel!
    
    private let chatPresenter = ChatPresenter(chatInteractor: ChatInteractorImpl(chatService: ChatServiceImpl(), initialMessagesList: []))
    private var newMessagesListenerToggleSubject: PublishSubject<Bool>!
    private var batchFetchTriggerSubject: PublishSubject<String>!
    
    var eventId = ""
    
    private var initialize = true
    
    private var messages: [Message] = [] {
        didSet {
            messagesTableView.reloadData()
        }
    }
    
    func prepare(eventId: String) {
        self.eventId = eventId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.tableFooterView = UIView()
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        messageTextView.isScrollEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initEmitters()
        chatPresenter.bind(chatView: self, eventId: eventId)
        if initialize {
            newMessagesListenerToggleSubject.onNext(true)
            batchFetchTriggerSubject.onNext(getCurrentISODate())
            initialize = false
        }
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
            .do(onNext: { _ in
                self.messageTextView.isScrollEnabled = false
                self.messageTextView.text = "" })
    }
    
    func render(chatViewState: ChatViewState) {
        showProgress(show: chatViewState.progress)
        showIncentiveText(show: chatViewState.messagesList.isEmpty && !chatViewState.progress)
        messages = chatViewState.messagesList
    }
    
    private func showProgress(show: Bool) {
        if show {
            progressView.startAnimating()
        } else {
            progressView.stopAnimating()
        }
    }
    
    private func showIncentiveText(show: Bool) {
        hintLabel.isHidden = !show
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        switch message.type {
        case .sent:
            let sentMessageCell = getSentMessageCell(tableView: tableView, indexPath: indexPath)
            sentMessageCell.bind(message: message.text, isSent: message.isSent)
            sentMessageCell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            return sentMessageCell
        case .received:
            let receivedMessageCell = getReceivedMessageCell(tableView: tableView, indexPath: indexPath)
            receivedMessageCell.bind(message: message.text, name: message.senderName, profilePictureUrl: message.senderImageUrl)
            receivedMessageCell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            return receivedMessageCell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height - messagesTableView.frame.size.height
        if actualPosition >= contentHeight && contentHeight > 0 {
            guard let lastTimestamp = messages.last?.timestamp else { return }
            batchFetchTriggerSubject.onNext(lastTimestamp)
        }
    }
    
    private func getSentMessageCell(tableView: UITableView, indexPath: IndexPath) -> SentMessageCell {
        return tableView.dequeueReusableCell(withIdentifier: SENT_MESSAGE_CELL, for: indexPath) as! SentMessageCell
    }
    
    private func getReceivedMessageCell(tableView: UITableView, indexPath: IndexPath) -> ReceivedMessageCell {
        return tableView.dequeueReusableCell(withIdentifier: RECEIVED_MESSAGE_CELL, for: indexPath) as! ReceivedMessageCell
    }
}
