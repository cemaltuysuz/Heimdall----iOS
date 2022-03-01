//
//  EditProfileConfigure.swift
//  Logoo
//
//  Created by cemal tüysüz on 1.03.2022.
//

import Foundation

struct EditProfileConfigure {
    
    var key:String!
    var value:String!
    var isEditable:Bool!
    var type:UserFieldType!
    
    init(key: String? = nil, value: String? = nil, isEditable: Bool? = nil, type: UserFieldType? = nil) {
       self.key = key
       self.value = value
       self.isEditable = isEditable
       self.type = type
   }
    
}
