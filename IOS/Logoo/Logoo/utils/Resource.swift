//
//  GeneralResponse.swift
//  Logoo
//
//  Created by cemal tüysüz on 9.02.2022.
//

import Foundation

class Resource <T> {
    
    var status:Status?
    var data:T?
    var message:String?
    
    init(){}
    
    init(status:Status?, data:T?, message:String?){
        self.status = status
        self.data = data
        self.message = message
    }
}

enum Status {
    case SUCCESS
    case LOADING
    case ERROR
}
