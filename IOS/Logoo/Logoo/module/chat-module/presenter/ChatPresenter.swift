//
//  ChatPresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 28.05.2022.
//

import Foundation

class ChatPresenter : ViewToPresenterChatProtocol, InteractorToPresenterChatProtocol {
    
    var view: PresenterToViewChatProtocol?
    var interactor: PresenterToInteractorChatProtocol?
    
    func connectMessages(_ connectionUid: String) {
        interactor?.connectMessages(connectionUid)
    }
    
    func onStateChange(state: ChatState) {
        view?.onStateChange(state: state)
    }
    
    func sendMessage(_ text: String) {
        interactor?.sendMessage(text)
    }
    
}
