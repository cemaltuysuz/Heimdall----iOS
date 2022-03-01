//
//  Inbox.swift
//  Logoo
//
//  Created by cemal tüysüz on 22.02.2022.
//

import Foundation

class Inbox {
    var inboxId:String?
    var inboxInfoReference:String?
    var inboxMessageReference:String?
    var inboxType:InboxType?
    
    init(inboxId:String,inboxInfoReference:String,inboxMessageReference:String,inboxType:InboxType){
        self.inboxId = inboxId
        self.inboxInfoReference = inboxInfoReference
        self.inboxMessageReference = inboxMessageReference
        self.inboxType = inboxType
    }
}
