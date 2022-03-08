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
    var hasCheckForAlreadyUsed:Bool!
    var editType:EditFieldType!
    var fieldType:UserFieldType!
    var validator:Validatable?
    
    init(displayName:String? = nil, value: String? = nil, hasCheckForAlreadyUsed:Bool? = nil, editType: EditFieldType? = nil, fieldType:UserFieldType? = nil, validator:Validatable? = nil) {
        
       self.displayName = displayName
       self.value = value
       self.hasCheckForAlreadyUsed = hasCheckForAlreadyUsed
       self.editType = editType
       self.fieldType = fieldType
       self.validator = validator
   }
}
