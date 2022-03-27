//
//  ProfileOuterOption.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.02.2022.
//

import Foundation

struct MenuItem<T:Itemable>  {
    
    var iconName:String!
    var itemTitle:String!
    var type:T!
    var isEnabled:Bool!
    var warningMessage:String?
    
    init(iconName: String? = nil, itemTitle: String? = nil, type:T? = nil, isEnabled:Bool? = true, warningMessage:String? = nil) {
        self.iconName = iconName
        self.itemTitle = itemTitle
        self.type = type
        self.isEnabled = isEnabled
        self.warningMessage = warningMessage
    }
}

protocol Itemable {}
