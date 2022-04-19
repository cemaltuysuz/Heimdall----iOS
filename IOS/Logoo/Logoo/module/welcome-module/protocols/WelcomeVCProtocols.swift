//
//  WelcomeVCProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 17.02.2022.
//

import Foundation

protocol ViewToPresenterWelcomeProtocol {
    var view:PresenterToViewWelcomeProtocol? {get set}
    var interactor:PresenterToInteractorWelcomeProtocol? {get set}
    
    func routeUser()
}

protocol PresenterToInteractorWelcomeProtocol{
    var presenter:InteractorToPresenterWelcomeProtocol? {get set}
    func routeUser()
}

protocol InteractorToPresenterWelcomeProtocol {
    func onStateChange(_ state:WelcomeState)
}

protocol PresenterToViewWelcomeProtocol {
    func onStateChange(_ state:WelcomeState)
}

protocol PresenterToRouterWelcomeProtocol{
    static func createModule(ref:WelcomeVC)
}
