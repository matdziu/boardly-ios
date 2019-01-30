//
//  RawMessage.swift
//  Boardly
//
//  Created by Mateusz Dziubek on 30/01/2019.
//  Copyright © 2019 Mateusz Dziubek. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct RawMessage: Equatable {
    
    var id: String = ""
    var text: String = ""
    var senderId: String = ""
    var timestamp: String = ""
    var senderName: String = ""
    var senderImageUrl: String = ""
    
    init(id: String = "",
         text: String = "",
         senderId: String = "",
         timestamp: String = "",
         senderName: String = "",
         senderImageUrl: String = "") {
        self.id = id
        self.text = text
        self.senderId = senderId
        self.timestamp = timestamp
        self.senderName = senderName
        self.senderImageUrl = senderImageUrl
    }
    
    init(snapshot: DataSnapshot) {
        let value = snapshot.value as? [String : Any] ?? [:]
        self.id = value["id"] as? String ?? ""
        self.text = value["text"] as? String ?? ""
        self.senderId = value["senderId"] as? String ?? ""
        self.timestamp = value["timestamp"] as? String ?? ""
        self.senderName = value["senderName"] as? String ?? ""
        self.senderImageUrl = value["senderImageUrl"] as? String ?? ""
    }
    
    func toMessage(currentUserId: String, isSent: Bool = true) -> Message {
        return Message(id: self.id,
                       text: self.text,
                       isSent: isSent,
                       senderName: self.senderName,
                       senderImageUrl: self.senderImageUrl,
                       timestamp: self.timestamp,
                       type: getMessageType(for: currentUserId))
    }
    
    private func getMessageType(for currentUserId: String) -> MessageType {
        if self.senderId == currentUserId {
            return MessageType.sent
        } else {
            return MessageType.received
        }
    }
}
