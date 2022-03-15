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
    
    func sections(sections:[SecuritySectionType])
    func securityItems(items:[UserMenuItem])
    func loginTransactions(transactions:UserTransaction)
}

protocol PresenterToViewSecurityProtocol  {
    
    func sections(sections:[SecuritySectionType])
    func securityItems(items:[UserMenuItem])
    func loginTransactions(transactions:UserTransaction)
}

protocol PresenterToRouterSecurityProtocol {
    static func createModule(ref:SecurityVC)
}
