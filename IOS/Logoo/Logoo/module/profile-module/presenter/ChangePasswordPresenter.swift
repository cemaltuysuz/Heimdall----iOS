//
//  ChangePasswordPresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 5.04.2022.
//

import Foundation

class ChangePasswordPresenter : ViewToPresenterChangePasswordProtocol, InteractorToPresenterChangePasswordProtocol {
    var interactor: PresenterToInteractorChangePasswordProtocol?
    var view: PresenterToViewChangePasswordProtocol?
    
    func resetPasswordRequest(currentPassword: String) {
        interactor?.resetPasswordRequest(currentPassword: currentPassword)
    }
    
    func onStateChange(state: ChangePasswordState) {
        view?.onStateChange(state: state)
    }
    
}
