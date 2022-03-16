//
//  ProfileSettingsPresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.02.2022.
//

import Foundation

class ProfileSettingsPresenter : ViewToPresenterProfileSettingsProtocol, InteractorToPresenterProfileSettingsProtocol {
    
    var interactor: PresenterToInteractorProfileSettingsProtocol?
    var view: PresenterToViewProfileSettingsProtocol?
    
    
    
    func getOptions() {
        interactor?.getOptions()
    }

    
    func optionsToPresenter(options: [MenuItem<ProfileSettingType>]) {
        view?.optionsToView(options: options)
    }
    
    func exitUser() {
        self.interactor?.exitUser()
    }
    
    func exitUserFeedback() {
        self.view?.exitUserFeedback()
    }
}
