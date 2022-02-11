//
//  LoginRouterProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 11.02.2022.
//

import Foundation

protocol ViewToPresenterLoginRouterProtocol {
    var view:PresenterToViewLoginRouterProtocol? {get set}
    var interactor:PresenterToInteractorLoginRouterProtocol? {get set}
    
    func route()
}

protocol PresenterToInteractorLoginRouterProtocol {
    var presenter:InteractorToPresenterLoginRouterProtocol? {get set}
    
    func route()
}

protocol InteractorToPresenterLoginRouterProtocol {
    func loginToHomeVC()
    func loginToInterestSelectionVC(userId:String)
    func loginToErrorVC(message:String)
}

protocol PresenterToViewLoginRouterProtocol{
    func loginToHomeVC()
    func loginToInterestSelectionVC(userId:String)
    func loginToErrorVC(message:String)
}

protocol PresenterToRouterLoginRouterProtocol {
    static func createModule(ref:LoginRouterVC)
}
