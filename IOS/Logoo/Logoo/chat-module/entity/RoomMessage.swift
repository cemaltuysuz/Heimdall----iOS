//
//  RoomMessage.swift
//  Logoo
//
//  Created by cemal tüysüz on 25.01.2022.
//

import Foundation

class RoomMessage {
    
    var roomId:String?
    var messageId:String?
    var senderId:String?
    var timestamp:String?
    var message:String?
    var messageType:MessageType?
    var isRead:String?
    
     init(roomId: String, messageId: String, senderId: String, timestamp: String, message: String, messageType: MessageType, isRead: String) {
        self.roomId = roomId
        self.messageId = messageId
        self.senderId = senderId
        self.timestamp = timestamp
        self.message = message
        self.messageType = messageType
        self.isRead = isRead
    }
}
