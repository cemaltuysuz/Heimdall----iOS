//
//  ProfileSettingsProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.02.2022.
//

import Foundation

protocol ViewToPresenterSettingsProtocol {
    var view:PresenterToViewSettingsProtocol? {get set}
    var interactor:PresenterToInteractorSettingsProtocol? {get set}
    
    func getOptions()
    func exitUser()
}

protocol PresenterToInteractorSettingsProtocol {
    var presenter:InteractorToPresenterSettingsProtocol? {get set}
    func getOptions()
    func exitUser()
}

protocol InteractorToPresenterSettingsProtocol {
    func optionsToPresenter(options:[LineMenuItem])
    func exitUserFeedback()
}

protocol PresenterToViewSettingsProtocol {
    func optionsToView(options:[LineMenuItem])
    func exitUserFeedback()
}

protocol PresenterToRouterSettingsProtocol {
    static func createModule(ref:SettingsVC)
}
