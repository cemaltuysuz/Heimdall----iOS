//
//  ProfileSettingsPresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.02.2022.
//

import Foundation

class SettingsPresenter : ViewToPresenterSettingsProtocol, InteractorToPresenterSettingsProtocol {
    
    var interactor: PresenterToInteractorSettingsProtocol?
    var view: PresenterToViewSettingsProtocol?
    
    
    
    func getOptions() {
        interactor?.getOptions()
    }
    
    func optionsToPresenter(options: [LineMenuItem]) {
        view?.optionsToView(options: options)
    }
    
    func exitUser() {
        self.interactor?.exitUser()
    }
}
