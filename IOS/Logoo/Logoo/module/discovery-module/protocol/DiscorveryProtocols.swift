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
    func onStateChange(state:DiscoveryState)
}

protocol PresenterToViewDiscorveryProtocol {
    func onStateChange(state:DiscoveryState)
}

protocol PresenterToRouterDiscorveryProtocol {
    static func createModule(ref:DiscoverVC)
}
