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
    
    func getOptions()
    func exitUser()
}

protocol PresenterToInteractorProfileSettingsProtocol {
    var presenter:InteractorToPresenterProfileSettingsProtocol? {get set}
    func getOptions()
    func exitUser()
}

protocol InteractorToPresenterProfileSettingsProtocol {
    func optionsToPresenter(options:[LineMenuItem])
    func exitUserFeedback()
}

protocol PresenterToViewProfileSettingsProtocol {
    func optionsToView(options:[LineMenuItem])
    func exitUserFeedback()
}

protocol PresenterToRouterProfileSettingsProtocol {
    static func createModule(ref:ProfileSettingsVC)
}
