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
    
    init(iconName: String? = nil, optionTitle: String? = nil) {
        self.iconName = iconName
        self.optionTitle = optionTitle
    }
}
