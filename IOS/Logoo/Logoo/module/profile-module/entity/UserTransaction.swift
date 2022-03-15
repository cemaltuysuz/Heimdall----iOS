//
//  LoginTransaction.swift
//  Logoo
//
//  Created by cemal tüysüz on 15.03.2022.
//

import Foundation
import UIKit

struct UserTransaction {
    
    var systemType:LoginSystemType?
    var event:String?
    var date:String?
    
    init(systemType:LoginSystemType, event:String, date:String){
        self.systemType = systemType
        self.event = event
        self.date = date
    }
    
    func getIconByAction() -> UIImage?{
        if let event = event, let type = LogEventType(rawValue: event) {
            switch type {
            case .USER_SIGN_IN:
                return UIImage() // TODO
            case .USER_SIGN_OUT:
                break
            case .USER_PASSWORD_CHANGE:
                break
            case .USER_MAIL_CHANGE:
                break
            }
        }
        return nil
    }
}
