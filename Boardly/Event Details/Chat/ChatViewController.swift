//
//  ChatViewController.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 01/02/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import UIKit

class ChatViewController: UIViewController {
    
    private let chatPresenter = ChatPresenter(chatInteractor: ChatInteractorImpl(chatService: ChatServiceImpl(), initialMessagesList: []))
}
