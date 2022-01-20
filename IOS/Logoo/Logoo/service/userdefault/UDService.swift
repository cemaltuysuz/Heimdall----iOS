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
        return ud.bool(forKey: Constants.UserDefault.onboardVisibility.rawValue)
    }
    
    func changeOnboardVisibilityInfo(value:Bool) {
        ud.set(value, forKey: Constants.UserDefault.onboardVisibility.rawValue)
    }
}
