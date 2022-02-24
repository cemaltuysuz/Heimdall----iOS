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
    
    func getDiscoveredUsers() {
        interactor?.getDiscoveredUsers()
    }
    
    func discoveredUsersResponse(response: Resource<[User]>) {
        view?.discoveredUsersResponse(response: response)
    }
}
