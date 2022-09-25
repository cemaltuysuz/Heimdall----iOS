//
//  ProfileProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 7.04.2022.
//

import Foundation

protocol ViewToPresenterProfileProtocol {
    var interactor:PresenterToInteractorProfileProtocol? {get set}
    var view:PresenterToViewProfileProtocol? {get set}
    
    func loadPage(_ uid:String?)
    func sendToRequest(_ uid:String?)
}

protocol PresenterToInteractorProfileProtocol {
    var presenter:InteractorToPresenterProfileProtocol? {get set}
    
    func loadPage(_ uid:String?)
    func sendToRequest(_ uid:String?)
}

protocol InteractorToPresenterProfileProtocol {
    func onStateChange(state:ProfileState)
}

protocol PresenterToViewProfileProtocol {
    func onStateChange(state:ProfileState)
}

protocol PresenterToRouterProfileProtocol {
    static func createModule(ref:ProfileVC)
}
