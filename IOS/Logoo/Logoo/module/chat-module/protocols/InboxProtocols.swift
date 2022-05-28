//
//  ChatProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.01.2022.
//

import Foundation

 protocol ViewToPresenterInboxProtocol {
     var view:PresenterToViewInboxProtocol? {get set}
     var interactor:PresenterToInteractorInboxProtocol? {get set}
     
     func startConnection()
     func confirmRequest(_ request:Request)
 }

 protocol PresenterToInteractorInboxProtocol{
     var presenter:InteractorToPresenterInboxProtocol? {get set}
     
     func startConnection()
     func confirmRequest(_ request:Request)
 }

 protocol InteractorToPresenterInboxProtocol {
     func onStateChange(state:InboxState)
 }

 protocol PresenterToViewInboxProtocol {
     func onStateChange(state:InboxState)
 }

 protocol PresenterToRouterInboxProtocol {
     static func createModule(ref:InboxVC)
 }
 
