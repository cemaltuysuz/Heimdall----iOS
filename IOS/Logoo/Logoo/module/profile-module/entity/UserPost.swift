//
//  UserPost.swift
//  Logoo
//
//  Created by cemal tüysüz on 7.04.2022.
//

import Foundation

struct UserPost : Codable {
    
    var postUrl:String?
    var timestamp:Int64?
    var userPostType:String?
 
    init(postUrl: String? = nil, timestamp: Int64? = nil, userPostType: String? = nil) {
        self.postUrl = postUrl
        self.timestamp = timestamp
        self.userPostType = userPostType
    }
}
