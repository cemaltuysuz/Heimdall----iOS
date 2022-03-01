//
//  Room.swift
//  Logoo
//
//  Created by cemal tüysüz on 23.02.2022.
//

import Foundation

struct Room {
    
    var roomId:String?
    var hostId:String?
    var title:String?
    var description:String?
    var imageUrl:String?
    var creationTime:Int64?
    var members:[String]?
    var isClosed:Bool?
    var lastMessage:String?
    
    internal init(roomId: String? = nil, hostId: String? = nil, title: String? = nil, description: String? = nil, imageUrl: String? = nil, creationTime: Int64? = nil, members: [String]? = nil, isClosed: Bool? = nil, lastMessage: String? = nil) {
        self.roomId = roomId
        self.hostId = hostId
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.creationTime = creationTime
        self.members = members
        self.isClosed = isClosed
        self.lastMessage = lastMessage
    }
}
