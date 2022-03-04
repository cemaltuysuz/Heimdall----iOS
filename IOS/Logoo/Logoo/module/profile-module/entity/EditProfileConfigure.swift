//
//  EditProfileConfigure.swift
//  Logoo
//
//  Created by cemal tüysüz on 1.03.2022.
//

import Foundation

struct EditProfileConfigure {
    
    var displayName:String!
    var value:String!
    var isEditable:Bool!
    var hasPickerView:Bool!
    var type:UserFieldType!
    var validator:Validatable?
    
    init(displayName:String? = nil, value: String? = nil, isEditable: Bool? = nil, hasPickerView:Bool?, type: UserFieldType? = nil, validator:Validatable? = nil) {
        
       self.displayName = displayName
       self.value = value
       self.isEditable = isEditable
       self.hasPickerView = hasPickerView
       self.type = type
       self.validator = validator
   }
}