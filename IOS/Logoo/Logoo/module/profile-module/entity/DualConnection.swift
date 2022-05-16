//
//  DualConnection.swift
//  Logoo
//
//  Created by cemal tüysüz on 9.05.2022.
//

import Foundation

struct DualConnection : Codable {
    
    var connectionKey:String!
    var timestamp:String!
    
    init(connectionKey: String? = nil, timestamp:String? = nil) {
        self.connectionKey = connectionKey
        self.timestamp = timestamp
    }
    
}
