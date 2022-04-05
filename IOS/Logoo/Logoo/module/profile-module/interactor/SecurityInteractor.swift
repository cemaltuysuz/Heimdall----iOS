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
        var isEnabledButton = true
        if let userProvider = Auth.auth().currentUser?.providerData[0].providerID, let type = ProviderType(rawValue: userProvider), type != .PASSWORD {
            isEnabledButton = false
        }
        
        var items = [MenuItem<SecurityItemType>]()
        items.append(MenuItem(iconName: "envelope.fill",
                              itemTitle: "Change Mail".localized(),
                              type: .CHANGE_MAIL,
                              isEnabled: isEnabledButton,
                              warningMessage: nil))
        
        items.append(MenuItem(iconName: "key.fill",
                              itemTitle: "Change Password".localized(),
                              type: .CHANGE_PASSWORD,
                              isEnabled: isEnabledButton))
        
        items.append(MenuItem(iconName: "lock.rotation",
                              itemTitle: "Login Transactions".localized(),
                              type: .LOGIN_TRANSACTIONS,
                              warningMessage: ""))
        
        presenter?.securityItems(items: items)
    }
}
