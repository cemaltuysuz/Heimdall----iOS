//
//  SecurityPresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 15.03.2022.
//

import Foundation

class SecurityPresenter : ViewToPresenterSecurityProtocol, InteractorToPresenterSecurityProtocol {
    
    var view: PresenterToViewSecurityProtocol?
    var interactor: PresenterToInteractorSecurityProtocol?
    
    func getSecurityItems() {
        interactor?.getSecurityItems()
    }
    
    func securityItems(items: [MenuItem<SecurityItemType>]) {
        view?.securityItems(items: items)
    }
}
