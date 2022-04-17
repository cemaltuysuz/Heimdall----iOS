//
//  ProfileOuterOption.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.02.2022.
//

import Foundation

struct LineMenuItem {
    
    var iconName:String!
    var itemTitle:String!
    var rawValue:Int!
    var isEnabled:Bool!
    var isWarningButtonEnabled:Bool!
    var warningMessage:String?
    
    init(iconName: String? = nil, itemTitle: String? = nil, rawValue:Int? = nil, isEnabled:Bool? = true, isWarningButtonEnabled:Bool? = false, warningMessage:String? = nil) {
        self.iconName = iconName
        self.itemTitle = itemTitle
        self.rawValue = rawValue
        self.isEnabled = isEnabled
        self.isWarningButtonEnabled = isWarningButtonEnabled
        self.warningMessage = warningMessage
    }
}

