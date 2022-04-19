//
//  CustomUITextFieldProtocol.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.04.2022.
//

import Foundation

protocol CustomUITextFieldProtocol : AnyObject {
     func onRightButtonClick(_ textField:CustomUITextField,isActive:Bool)
     func onValidateResult(_ textField:CustomUITextField, validateResult:ValidateResult)
}

// optional
extension CustomUITextFieldProtocol {
    func onRightButtonClick(_ textField:CustomUITextField,isActive:Bool){}
    func onValidateResult(_ textField:CustomUITextField, validateResult:ValidateResult){}
}
