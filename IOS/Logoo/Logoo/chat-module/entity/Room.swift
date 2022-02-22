//
//  RoomMessage.swift
//  Logoo
//
//  Created by cemal tüysüz on 25.01.2022.
//

import Foundation

class Room {
    var roomId:String?
    var creatorId:String?
    var roomTitle:String?
    var roomDescription:String?
    var roomImageUrl:String?
    var roomMembers:[User]?
    var creationTime:String?
    
    init(){
        
    }
    
     init(roomId: String, creatorId: String, roomTitle: String, roomDescription: String, roomImageUrl: String, roomMembers: [User], creationTime: String) {
        self.roomId = roomId
        self.creatorId = creatorId
        self.roomTitle = roomTitle
        self.roomDescription = roomDescription
        self.roomImageUrl = roomImageUrl
        self.roomMembers = roomMembers
        self.creationTime = creationTime
    }
    
}
