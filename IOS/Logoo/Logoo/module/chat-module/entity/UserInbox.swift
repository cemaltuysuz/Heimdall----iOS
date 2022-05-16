//
//  Inbox.swift
//  Logoo
//
//  Created by cemal tüysüz on 4.05.2022.
//

import Foundation

struct UserInbox : Codable {
    
    var inboxId:String!
    var inboxType:String!
    var infoKey:String!
    var messageKey:String!
    
    init(inboxId: String? = nil, inboxType: String? = nil, infoKey: String? = nil, messageKey: String? = nil) {
        self.inboxId = inboxId
        self.inboxType = inboxType
        self.infoKey = infoKey
        self.messageKey = messageKey
    }
    
    func getInboxType () -> InboxType? {
        let type = InboxType(rawValue: inboxType) ?? nil
        return type
    }
}
