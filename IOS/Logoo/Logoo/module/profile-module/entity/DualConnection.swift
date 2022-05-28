//
//  DualConnection.swift
//  Logoo
//
//  Created by cemal tüysüz on 9.05.2022.
//

import Foundation

struct DualConnection : Codable {
    var connectionKey:String!
    var timestamp:Int64!
    var lastMessage:String!
    var lastMessageTimestamp:Int64!
}
