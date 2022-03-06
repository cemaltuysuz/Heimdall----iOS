//
//  SimpleResponse.swift
//  Logoo
//
//  Created by cemal tüysüz on 4.03.2022.
//

import Foundation

struct SimpleResponse{
    
    var status:Bool?
    var message:String?
    
    init(status:Bool? = nil, message:String? = nil) {
        self.status = status
        self.message = message
    }
}
