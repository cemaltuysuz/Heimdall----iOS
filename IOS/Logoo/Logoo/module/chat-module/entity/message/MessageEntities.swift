//
//  CurrentMessager.swift
//  Logoo
//
//  Created by cemal tüysüz on 28.05.2022.
//

import Foundation
import MessageKit

struct CurrentMessager : SenderType {
    var senderId: String
    var displayName: String
    var photoUrl:String
}

struct OtherMessager : SenderType {
    var senderId: String
    var displayName: String
    var photoUrl:String
}

struct MessageLocal: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

// for firebase
struct MessageRemote : Codable {
    var messageID:String
    var timestamp:Int64
    var senderID:String
    var messageText:String
    var contentURL:String
}
