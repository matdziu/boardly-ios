//
//  ChatViewState.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct ChatViewState: Equatable {
    
    var progress: Bool = true
    var messagesList: [Message] = []
    
    init(progress: Bool = true,
         messagesList: [Message] = []) {
        self.progress = progress
        self.messagesList = messagesList
    }
}
