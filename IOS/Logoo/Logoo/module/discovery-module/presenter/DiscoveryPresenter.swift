//
//  DiscoveryPresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 23.01.2022.
//

import Foundation

class DiscoveryPresenter : ViewToPresenterDiscorveryProtocol, InteractorToPresenterDiscorveryProtocol{
    var interactor: PresenterToInteractorDiscoveryProtocol?
    var view: PresenterToViewDiscorveryProtocol?
    
    func getDiscoveredUsers(_ limit: Int) {
        interactor?.getDiscoveredUsers(limit)
    }
    
    func searchUser(_ keyword: String) {
        interactor?.searchUser(keyword)
    }
    
    func resetPagination() {
        interactor?.resetPagination()
    }
    
    func onStateChange(state: DiscoveryState) {
        view?.onStateChange(state: state)
    }
}
