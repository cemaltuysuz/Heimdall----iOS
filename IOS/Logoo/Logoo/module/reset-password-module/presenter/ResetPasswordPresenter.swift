//
//  File.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.02.2022.
//

import Foundation

class ResetPasswordPresenter :ViewToPresenterResetPasswordProtocol, InteractorToPresenterResetPasswordProtocol{
    var view: PresenterToViewResetPasswordProtocol?
    var interactor: PresenterToInteractorResetPasswordProtocol?
    
    
    func sendResetLink(mail: String) {
        interactor?.sendResetLink(mail: mail)
    }
    
    func sendLinkResponse(resp: Status) {
        view?.sendLinkResponse(resp: resp)
    }
    
    
    
}
