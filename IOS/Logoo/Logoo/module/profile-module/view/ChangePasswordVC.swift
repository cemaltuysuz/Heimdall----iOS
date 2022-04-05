//
//  ChangePasswordVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 5.04.2022.
//

import UIKit

class ChangePasswordVC: BaseVC {
    
    var presenter:ViewToPresenterChangePasswordProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        createModule()
    }
    
    func configureUI(){
        
    }
    
    func createModule() {
        ChangePasswordRouter.createModule(ref: self)
    }
}

extension ChangePasswordVC : PresenterToViewChangePasswordProtocol {
    func onStateChange(state: ChangePasswordState) {
        switch state {
        case .CLEAR_CURTAIN:
            <#code#>
        case .CURTAIN:
            <#code#>
        case .CHANGE_PASSWORD_SUCCESS:
            <#code#>
        case .CHANGE_PASSWORD_FAIL( _):
            <#code#>
        }
    }
}

enum ChangePasswordState {
    case CLEAR_CURTAIN
    case CURTAIN
    case CHANGE_PASSWORD_SUCCESS
    case CHANGE_PASSWORD_FAIL(message:String)
}
