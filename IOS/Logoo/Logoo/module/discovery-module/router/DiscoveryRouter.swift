//
//  DiscoveryRouter.swift
//  Logoo
//
//  Created by cemal tüysüz on 23.01.2022.
//

import Foundation

class DiscoveryRouter : PresenterToRouterDiscorveryProtocol{
    
    static func createModule(ref: DiscoverVC) {
        
        let presenter = DiscoveryPresenter()
        
        ref.presenter = presenter
        ref.presenter?.interactor = DiscoveryInteractor()
        ref.presenter?.view = ref
        ref.presenter?.interactor?.presenter = presenter
    }
}
