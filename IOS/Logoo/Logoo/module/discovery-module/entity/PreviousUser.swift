//
//  PreviousUser.swift
//  Logoo
//
//  Created by cemal tüysüz on 19.04.2022.
//

import Foundation

class PreviousUser : Codable {
    var uid:String?
    var timestamp:Int64?
    
    init(uid:String? = nil, timestamp:Int64? = nil) {
        self.uid = uid
        self.timestamp = timestamp
    }
}
