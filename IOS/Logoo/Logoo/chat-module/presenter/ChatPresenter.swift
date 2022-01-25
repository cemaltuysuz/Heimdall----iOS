//
//  ChatPresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 25.01.2022.
//

import Foundation

class ChatPresenter : ViewToPresenterChatProtocol, InteractorToPresenterChatProtocol {
    
    var view: PresenterToViewChatProtocol?
    var interactor: PresenterToInteractorChatProtocol?
    
    
    
    func getAllRequirements() {
        interactor?.getAllRequirements()
    }
    
    func requestsToPresenter(requests: [ChatRequest]) {
        view?.requestsToView(requests: requests)
    }
    
    
    func chatsToPresenter(chats: [Any]) {
        view?.chatsToView(chats: chats)
    }
}
