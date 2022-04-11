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
        
        var items = [LineMenuItem]()
        items.append(LineMenuItem(iconName: "envelope.fill",
                                  itemTitle: "Change Mail".localized(),
                                  rawValue: SecurityMenuItemType.CHANGE_MAIL.rawValue,
                                  isEnabled: isEnabledButton,
                                  warningMessage: nil))
        
        items.append(LineMenuItem(iconName: "key.fill",
                                  itemTitle: "Change Password".localized(),
                                  rawValue: SecurityMenuItemType.CHANGE_PASSWORD.rawValue,
                                  isEnabled: true))
        
        items.append(LineMenuItem(iconName: "lock.rotation",
                                  itemTitle: "Login Transactions".localized(),
                                  rawValue: SecurityMenuItemType.LOGIN_TRANSACTIONS.rawValue,
                                  warningMessage: ""))
        
        presenter?.securityItems(items: items)
    }
}
