//
//  EditProfileConfigure.swift
//  Logoo
//
//  Created by cemal tüysüz on 1.03.2022.
//

import Foundation

struct EditFieldConfigure {
    
    var displayName:String!
    var key:String!
    var value:String!
    var hasCheckForAlreadyUsed:Bool!
    var editType:EditFieldType!
    var validator:Validatable?
    var fieldLeftIconName:String?
    
    init(displayName:String? = nil, key:String? = nil, value: String? = nil, hasCheckForAlreadyUsed:Bool? = nil, editType: EditFieldType? = nil, validator:Validatable? = nil, fieldLeftIconName:String? = nil) {
        
       self.displayName = displayName
       self.key = key
       self.value = value
       self.hasCheckForAlreadyUsed = hasCheckForAlreadyUsed
       self.editType = editType
       self.validator = validator
       self.fieldLeftIconName = fieldLeftIconName
   }
}
