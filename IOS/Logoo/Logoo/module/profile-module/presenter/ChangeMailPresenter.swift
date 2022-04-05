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
    
    func changeMailRequest(currentPassword: String, newMail: String) {
        interactor?.changeMailRequest(currentPassword: currentPassword, newMail: newMail)
    }
    
    func onStateChange(state: ChangeMailState) {
        view?.onStateChange(state: state)
    }
    
    
}
