//
//  ValidationResponse.swift
//  Logoo
//
//  Created by cemal tüysüz on 22.01.2022.
//

import Foundation

class ValidationResponse {
    var status:Bool?
    var message:String?
    
    init(){}
    
    init(status:Bool,message:String?){
        self.status = status
        self.message = message
    }
}
