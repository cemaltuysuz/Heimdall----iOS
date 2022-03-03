//
//  ValidateResult.swift
//  Logoo
//
//  Created by cemal tüysüz on 3.03.2022.
//

import Foundation

struct ValidateResult {
    let isSuccess:Bool!
    let message:String?
    
    init(isSuccess:Bool, message:String){
        self.isSuccess = isSuccess
        self.message = message
    }
}
