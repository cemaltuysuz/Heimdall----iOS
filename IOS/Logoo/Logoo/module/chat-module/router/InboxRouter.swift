//
//  ChatRouter.swift
//  Logoo
//
//  Created by cemal tüysüz on 25.01.2022.
//

import Foundation

class InboxRouter  {
    
    static func createModule(ref: InboxVC) {
        let p = InboxPresenter()
        
        ref.presenter = p
        ref.presenter?.interactor = InboxInteractor()
        ref.presenter?.view = ref
        ref.presenter?.interactor?.presenter = p
    }
}
