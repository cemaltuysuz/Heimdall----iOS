//
//  ChatRouter.swift
//  Logoo
//
//  Created by cemal tüysüz on 28.05.2022.
//

import Foundation

class ChatRouter : PresenterToRouterChatProtocol {
    
    static func createModule(ref: ChatVC) {
        
        let p = ChatPresenter()
        ref.presenter = p
        ref.presenter?.view = ref
        ref.presenter?.interactor = ChatInteractor()
        ref.presenter?.interactor?.presenter = p
        
    }
}
