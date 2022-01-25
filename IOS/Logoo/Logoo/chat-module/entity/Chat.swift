//
//  Inbox.swift
//  Logoo
//
//  Created by cemal tüysüz on 25.01.2022.
//

import Foundation

class Chat {
    var userId:String?
    var chatId:String?
    var chatType:ChatType?
    
    init(){}
    
    init(userId:String, chatId:String, chatType:ChatType){
        self.userId = userId
        self.chatId = chatId
        self.chatType = chatType
    }
}
