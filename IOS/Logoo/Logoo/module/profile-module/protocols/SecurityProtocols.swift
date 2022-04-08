//
//  SecurityProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 15.03.2022.
//

import Foundation


protocol ViewToPresenterSecurityProtocol {
    var view:PresenterToViewSecurityProtocol? {get set}
    var interactor:PresenterToInteractorSecurityProtocol? {get set}
    
    func getSecurityItems()
}

protocol PresenterToInteractorSecurityProtocol {
    var presenter:InteractorToPresenterSecurityProtocol?{get set}

    func getSecurityItems()
}

protocol InteractorToPresenterSecurityProtocol {
    
    func securityItems(items:[LineMenuItem])
}

protocol PresenterToViewSecurityProtocol  {
    
    func securityItems(items:[LineMenuItem])
}

protocol PresenterToRouterSecurityProtocol {
    static func createModule(ref:SecurityVC)
}
