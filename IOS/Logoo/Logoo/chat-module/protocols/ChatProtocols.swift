//
//  ChatProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.01.2022.
//

import Foundation


protocol ViewToPresenterChatProtocol {
    var view:PresenterToViewChatProtocol? {get set}
    var interactor:PresenterToInteractorChatProtocol? {get set}
    
    func getAllChats()
}

protocol PresenterToInteractorChatProtocol{
    var presenter:InteractorToPresenterChatProtocol? {get set}
    func getAllChats()
}

protocol InteractorToPresenterChatProtocol {
    func roomChatsToPresenter(room:[Room])
    func p2pChatsToPresenter(p2p:[P2P])
}

protocol PresenterToViewChatProtocol {
    func roomChatsToView(room:[Room])
    func p2pChatsToView(p2p:[P2P])
}

protocol PresenterToRouterChatProtocol {
    static func createModule(ref:ChatVC)
}
