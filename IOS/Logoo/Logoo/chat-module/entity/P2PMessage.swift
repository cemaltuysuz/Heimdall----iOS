//
//  P2PMessage.swift
//  Logoo
//
//  Created by cemal tüysüz on 25.01.2022.
//

import Foundation

class P2PMessage {
    var p2pId:String?
    var messageId:String?
    var senderId:String?
    var receiverId:String?
    var timestamp:String?
    var messageType:MessageType?
    var message:String?
    var isRead:String?
    
    init(p2pId: String, messageId: String, senderId: String, receiverId: String, timestamp: String, messageType: MessageType, message: String, isRead: String) {
        self.p2pId = p2pId
        self.messageId = messageId
        self.senderId = senderId
        self.receiverId = receiverId
        self.timestamp = timestamp
        self.messageType = messageType
        self.message = message
        self.isRead = isRead
    }
}
