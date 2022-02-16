//
//  UDService.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import Foundation

class UDService : UDProtocol {
    
    private var ud = UserDefaults.standard
    static let shared = UDService()
    
    /*
     It keeps the information whether the on-board screen has been shown to the user before.
     Default return value is false.
     
     */
    func onboardVisibilityInfo() -> Bool {
        return ud.bool(forKey: Constants
                .UserDefault
                .ONBOARD_VISIBILITY
                .rawValue)
    }
    
    func changeOnboardVisibilityInfo(value:Bool) {
        ud.set(value, forKey: Constants
                .UserDefault
                .ONBOARD_VISIBILITY
                .rawValue)
    }
    
    func getConfirmEmailTime()->Int64 {
        return Int64(ud.integer(forKey: Constants
                                    .UserDefault
                                    .MAIL_CONFIRMATION_TIME
                                    .rawValue))
    }
    
    func setConfirmEmailTime(time:Int64) {
        ud.set(time, forKey: Constants
                .UserDefault
                .MAIL_CONFIRMATION_TIME
                .rawValue)
    }
    
    func setConfirmEmailSecond(second:Int64){
        ud.set(second, forKey: Constants
                .UserDefault
                .MAIL_CONFIRMATIN_SECOND
                .rawValue)
    }
    
    func getConfirmEmailSecond() -> Int64 {
        return Int64(ud.integer(forKey: Constants
                                    .UserDefault
                                    .MAIL_CONFIRMATIN_SECOND
                                    .rawValue))
    }
}
