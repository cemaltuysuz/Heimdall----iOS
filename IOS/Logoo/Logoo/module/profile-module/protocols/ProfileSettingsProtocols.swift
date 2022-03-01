//
//  ProfileSettingsProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.02.2022.
//

import Foundation

protocol ViewToPresenterProfileSettingsProtocol {
    var view:PresenterToViewProfileSettingsProtocol? {get set}
    var interactor:PresenterToInteractorProfileSettingsProtocol? {get set}
    
    func getUser()
    func getOptions()
}

protocol PresenterToInteractorProfileSettingsProtocol {
    var presenter:InteractorToPresenterProfileSettingsProtocol? {get set}
    func getUser()
    func getOptions()
}

protocol InteractorToPresenterProfileSettingsProtocol {
    func userToPresenter(user:User)
    func optionsToPresenter(options:[ProfileOuterOption])
}

protocol PresenterToViewProfileSettingsProtocol {
    func userToView(user:User)
    func optionsToView(options:[ProfileOuterOption])
}

protocol PresenterToRouterProfileSettingsProtocol {
    static func createModule(ref:ProfileSettingsVC)
}
