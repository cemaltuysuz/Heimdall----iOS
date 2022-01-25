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
    
    func getAllRequirements()
}

protocol PresenterToInteractorChatProtocol{
    var presenter:InteractorToPresenterChatProtocol? {get set}
    func getAllRequirements()
}

protocol InteractorToPresenterChatProtocol {
    func chatsToPresenter(chats:[Any])
    func requestsToPresenter(requests:[ChatRequest])
}

protocol PresenterToViewChatProtocol {
    func chatsToView(chats:[Any])
    func requestsToView(requests:[ChatRequest])
}

protocol PresenterToRouterChatProtocol {
    static func createModule(ref:ChatVC)
}
