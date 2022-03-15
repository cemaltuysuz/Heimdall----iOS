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
    
    func initialize()
    func getSections(sections:[SecuritySectionType])
    func getSecurityItems(items:[UserMenuItem])
    func getLoginTransactions()
}

protocol PresenterToInteractorSecurityProtocol {
    var presenter:InteractorToPresenterSecurityProtocol?{get set}
    
    func initialize()
    
    func getSections(sections:[SecuritySectionType])
    func getSecurityItems(items:[UserMenuItem])
    func getLoginTransactions()
    
}

protocol InteractorToPresenterSecurityProtocol {
    
    var sections:[SecuritySectionType]? {get set}
    var menuItems:[UserMenuItem]? {get set}
    
    func getLoginTransactions()
}

protocol PresenterToViewSecurityProtocol  {
    
}

protocol PresenterToRouterSecurityProtocol {
    static func createModule(ref:SecurityVC)
}
