//
//  ChatInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 25.01.2022.
//

import Foundation

class ChatInteractor  {
 //   var presenter: InteractorToPresenterChatProtocol?

    
    func getAllRequirements() {
        getRequests()
        getChats()
    }
    
    private func getChats(){
        var chatList = [Any]()
        var p2pMembers = [User]()
        var roomMembers = [User]()
        
       // presenter?.chatsToPresenter(chats: chatList)
    }
    
    private func getRequests(){
        var requests = [Any]()
        
   //     presenter?.requestsToPresenter(requests: requests)
    }
    
    
}
