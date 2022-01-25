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
    
    func getAllChats() {
        interactor?.getAllChats()
    }
    
    func roomChatsToPresenter(room: [Room]) {
        view?.roomChatsToView(room: room)
    }
    
    func p2pChatsToPresenter(p2p: [P2P]) {
        view?.p2pChatsToView(p2p: p2p)
    }
}
