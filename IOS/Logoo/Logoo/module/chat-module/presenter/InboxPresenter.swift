//
//  ChatPresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 25.01.2022.
//

import Foundation

class InboxPresenter : ViewToPresenterInboxProtocol, InteractorToPresenterInboxProtocol {
    var view: PresenterToViewInboxProtocol?
    var interactor: PresenterToInteractorInboxProtocol?
    
    func startConnection() {
        interactor?.startConnection()
    }
    
    func onStateChange(state: InboxState) {
        view?.onStateChange(state: state)
    }
}
