//
//  EditFieldCellProtocol.swift
//  Logoo
//
//  Created by cemal tüysüz on 9.03.2022.
//

import Foundation

protocol EditFieldCellProtocol : AnyObject {
    func updateField(fieldKey:String, fieldValue:String, reformable:Reformable)
}
