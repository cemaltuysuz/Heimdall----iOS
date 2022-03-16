//
//  SecurityInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 15.03.2022.
//

import Foundation
import FirebaseAuth

class SecurityInteractor : PresenterToInteractorSecurityProtocol {
    
    var presenter: InteractorToPresenterSecurityProtocol?
    
    func getSecurityItems() {
        
        var items = [MenuItem<SecurityItemType>]()
        items.append(MenuItem(iconName: "envelope.fill",
                              itemTitle: "Change Mail",
                              isEnabled: false))
        
        items.append(MenuItem(iconName: "key.fill",
                              itemTitle: "Change Password",
                              isEnabled: false))
        
        presenter?.securityItems(items: items)
    }
}
