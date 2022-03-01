//
//  WelcomeInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 17.02.2022.
//

import Foundation
import FirebaseAuth

class WelcomeInteractor : PresenterToInteractorWelcomeProtocol{
    
    var presenter: InteractorToPresenterWelcomeProtocol?
    
    func routeUser() {
        if !UDService.shared.onboardVisibilityInfo() {
            presenter?.goToOnBoard()
        }else {
            if let user = Auth.auth().currentUser, user.isEmailVerified {
                    presenter?.goToHome()
            }
             presenter?.goToLoginPref()
        }
    }
}
