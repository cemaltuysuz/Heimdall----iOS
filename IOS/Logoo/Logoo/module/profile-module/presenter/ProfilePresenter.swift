//
//  ProfilePresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 7.04.2022.
//

import Foundation

class ProfilePresenter : ViewToPresenterProfileProtocol, InteractorToPresenterProfileProtocol {
    var interactor: PresenterToInteractorProfileProtocol?
    var view: PresenterToViewProfileProtocol?
    
    func loadPage() {
        interactor?.loadPage()
    }
    
    func onStateChange(state: ProfileState) {
        view?.onStateChange(state: state)
    }
}
