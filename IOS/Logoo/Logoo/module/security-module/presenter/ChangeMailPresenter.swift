//
//  ChangeMailPresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 5.04.2022.
//

import Foundation

class ChangeMailPresenter : ViewToPresenterChangeMailProtocol, InteractorToPresenterChangeMailProtocol {
    
    var interactor: PresenterToInteractorChangeMailProtocol?
    
    var view: PresenterToViewChangeMailProtocol?
    
    func reAuthRequest(currentPassword: String) {
        interactor?.reAuthRequest(currentPassword: currentPassword)
    }
    
    func doChangeMail(mail: String) {
        interactor?.doChangeMail(mail: mail)
    }

    func onStateChange(state: ChangeMailState) {
        view?.onStateChange(state: state)
    }
    
    
}
