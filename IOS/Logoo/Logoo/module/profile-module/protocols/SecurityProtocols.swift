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
    func resetPassword()
}

protocol PresenterToInteractorSecurityProtocol {
    var presenter:InteractorToPresenterSecurityProtocol?{get set}

    func getSecurityItems()
    func resetPassword()
}

protocol InteractorToPresenterSecurityProtocol {
    
    func securityItems(items:[MenuItem<SecurityItemType>])
    func changePasswordResponse(response:SimpleResponse)
}

protocol PresenterToViewSecurityProtocol  {
    
    func securityItems(items:[MenuItem<SecurityItemType>])
    func changePasswordResponse(response:SimpleResponse)
}

protocol PresenterToRouterSecurityProtocol {
    static func createModule(ref:SecurityVC)
}
