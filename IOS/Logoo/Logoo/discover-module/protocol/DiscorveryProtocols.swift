//
//  DiscorveryProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 23.01.2022.
//

import Foundation

protocol ViewToPresenterDiscorveryProtocol {
    var view:PresenterToViewDiscorveryProtocol? {get set}
    var interactor:PresenterToInteractorDiscoveryProtocol? {get set}
    
    func getDiscoveredUsers()
}

protocol PresenterToInteractorDiscoveryProtocol {
    var presenter:InteractorToPresenterDiscorveryProtocol? {get set}
    
    func getDiscoveredUsers()
}

protocol InteractorToPresenterDiscorveryProtocol {
    func discoveredUsersToPresenter(users:[User])
}

protocol PresenterToViewDiscorveryProtocol {
    func discoveredUsersToView(users:[User])
}

protocol PresenterToRouterDiscorveryProtocol {
    static func createModule(ref:DiscoverVC)
}
