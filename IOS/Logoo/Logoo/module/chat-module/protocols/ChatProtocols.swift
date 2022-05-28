//
//  ChatProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 28.05.2022.
//

import Foundation

protocol ViewToPresenterChatProtocol {
    var view:PresenterToViewChatProtocol? {get set}
    var interactor:PresenterToInteractorChatProtocol? {get set}
    
    func connectMessages(_ connectionUid:String)
    func sendMessage(_ text:String)
}

protocol PresenterToInteractorChatProtocol {
    var presenter:InteractorToPresenterChatProtocol? {get set}
    
    func connectMessages(_ connectionUid:String)
    func sendMessage(_ text:String)
}

protocol InteractorToPresenterChatProtocol {
    func onStateChange(state:ChatState)
}

protocol PresenterToViewChatProtocol {
    func onStateChange(state:ChatState)
}

protocol PresenterToRouterChatProtocol {
    static func createModule(ref:ChatVC)
}
