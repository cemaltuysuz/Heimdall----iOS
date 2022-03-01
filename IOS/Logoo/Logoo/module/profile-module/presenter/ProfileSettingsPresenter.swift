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
    
    
    func getUser() {
        interactor?.getUser()
    }
    
    func getOptions() {
        interactor?.getOptions()
    }
    
    func userToPresenter(user: User) {
        view?.userToView(user: user)
    }
    
    func optionsToPresenter(options: [ProfileOuterOption]) {
        view?.optionsToView(options: options)
    }
}
