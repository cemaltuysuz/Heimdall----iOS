//
//  ChangeMailVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 5.04.2022.
//

import UIKit

class ChangeMailVC: BaseVC {
    
    var presenter : ViewToPresenterChangeMailProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        createModule()
    }
    
    func configureUI(){
        
    }
    
    func createModule() {
        ChangeMailRouter.createModule(ref: self)
    }
}

extension ChangeMailVC : PresenterToViewChangeMailProtocol {
    func onStateChange(state: ChangeMailState) {
        
    }
}

enum ChangeMailState {
    case CLEAR_CURTAIN
    case CURTAIN
    case CHANGE_PASSWORD_SUCCESS
    case CHANGE_PASSWORD_FAIL(message:String)
}
