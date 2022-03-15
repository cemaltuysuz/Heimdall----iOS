//
//  SecurityInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 15.03.2022.
//

import Foundation

class SecurityInteractor : PresenterToInteractorSecurityProtocol {
    var presenter: InteractorToPresenterSecurityProtocol?
    
    func initialize() {
        <#code#>
    }
    
    func getSections(sections: [SecuritySectionType]) {
        presenter?.sections(sections: SecuritySectionType.allCases)
    }
    
    func getSecurityItems(items: [UserMenuItem]) {
        var items = [UserMenuItem]()
        items.append(UserMenuItem(iconName: <#T##String?#>,
                                  optionTitle: <#T##String?#>,
                                  userSettingType: <#T##UserSettingType?#>,
                                  isEnabled: <#T##Bool?#>))
        
        items.append(UserMenuItem(iconName: <#T##String?#>,
                                  optionTitle: <#T##String?#>,
                                  userSettingType: <#T##UserSettingType?#>,
                                  isEnabled: <#T##Bool?#>))
        
        presenter?.securityItems(items: items)
    }
    
    func getLoginTransactions() {
        <#code#>
    }
    
    
}
