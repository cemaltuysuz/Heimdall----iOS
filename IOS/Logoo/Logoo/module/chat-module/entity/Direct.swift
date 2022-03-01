//
//  Direct.swift
//  Logoo
//
//  Created by cemal tüysüz on 23.02.2022.
//

import Foundation

struct Direct {
    var directId:String?
    var receiverId:String?
    var senderId:String?
    var messagePath:String?
    
    init(directId:String, receiverId:String, senderId:String, messagePath:String){
        self.directId = directId
        self.receiverId = receiverId
        self.senderId = senderId
        self.messagePath = messagePath
    }
}
