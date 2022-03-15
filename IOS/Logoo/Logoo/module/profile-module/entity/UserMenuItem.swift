//
//  ProfileOuterOption.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.02.2022.
//

import Foundation

struct UserMenuItem {
    
    var iconName:String!
    var optionTitle:String!
    var userSettingType:UserSettingType!
    var isEnabled:Bool!
    
    init(iconName: String? = nil, optionTitle: String? = nil, userSettingType:UserSettingType? = nil, isEnabled:Bool? = true) {
        self.iconName = iconName
        self.optionTitle = optionTitle
        self.userSettingType = userSettingType
        self.isEnabled = isEnabled
    }
}
