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
            guard let user = Auth.auth().currentUser, user.isEmailVerified else {
                do {
                    try Auth.auth().signOut()
                }catch{
                    print(error)
                }
                presenter?.goToLoginPref()
                return
            }
            presenter?.goToHome()
        }
    }
}
