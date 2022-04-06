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
    
    func resetPasswordRequest(currentPassword: String,newPassword:String) {
        interactor?.resetPasswordRequest(currentPassword: currentPassword, newPassword: newPassword)
    }
    
    func onStateChange(state: ChangePasswordState) {
        view?.onStateChange(state: state)
    }
    
}
