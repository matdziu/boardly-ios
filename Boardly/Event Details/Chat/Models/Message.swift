//
//  Message.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation

struct Message: Equatable {
    
    var id: String = ""
    var text: String = ""
    var isSent: Bool = false
    var senderName: String = ""
    var senderImageUrl: String = ""
    var timestamp: String = ""
    var type: MessageType
    
    init(id: String = "",
         text: String = "",
         isSent: Bool = false,
         senderName: String = "",
         senderImageUrl: String = "",
         timestamp: String = "",
         type: MessageType) {
        self.id = id
        self.text = text
        self.isSent = isSent
        self.senderName = senderName
        self.senderImageUrl = senderImageUrl
        self.timestamp = timestamp
        self.type = type
    }
}

enum MessageType {
    case sent, received
}
