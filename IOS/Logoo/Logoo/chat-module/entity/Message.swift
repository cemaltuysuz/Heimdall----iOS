//
//  Message.swift
//  Logoo
//
//  Created by cemal tüysüz on 23.02.2022.
//

import Foundation

struct Message {
    
    var messageId:String?
    var senderId:String?
    var text:String?
    var link:String?
    var timestamp:Int64?
    var messageType:MessageType?
    
    init(messageId: String? = nil, senderId: String? = nil, text: String? = nil, link: String? = nil, timestamp: Int64? = nil, messageType: MessageType? = nil) {
        self.messageId = messageId
        self.senderId = senderId
        self.text = text
        self.link = link
        self.timestamp = timestamp
        self.messageType = messageType
    }
}
