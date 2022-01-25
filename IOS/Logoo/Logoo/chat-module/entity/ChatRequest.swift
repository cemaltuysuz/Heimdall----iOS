//
//  ChatRequest.swift
//  Logoo
//
//  Created by cemal tüysüz on 25.01.2022.
//

import Foundation

class ChatRequest {
    
    var chatRequestId:String?
    var requestSenderId:String?
    var requestReceiverId:String?
    var requestType:RequestType?
    var timestamp:String?
    
    init(){}
    
     init(chatRequestId: String, requestSenderId: String, requestReceiverId: String, requestType: RequestType, timestamp: String) {
        self.chatRequestId = chatRequestId
        self.requestSenderId = requestSenderId
        self.requestReceiverId = requestReceiverId
        self.requestType = requestType
        self.timestamp = timestamp
    }
    
    
}



