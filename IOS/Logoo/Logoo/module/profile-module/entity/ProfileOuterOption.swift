//
//  ProfileOuterOption.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.02.2022.
//

import Foundation

struct ProfileOuterOption {
    
    var iconName:String!
    var optionTitle:String!
    var userSettingType:UserSettingType!
    
    init(iconName: String? = nil, optionTitle: String? = nil, userSettingType:UserSettingType? = nil) {
        self.iconName = iconName
        self.optionTitle = optionTitle
        self.userSettingType = userSettingType
    }
}
