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
            presenter?.onStateChange(.goToOnBoard)
        }else {
            guard let user = Auth.auth().currentUser, user.isEmailVerified else {
                do {
                    try Auth.auth().signOut()
                }catch{
                    print(error)
                }
                presenter?.onStateChange(.goToLoginPref)
                return
            }
            user.reload(completion: {error in
                guard let _ = error else {
                    self.presenter?.onStateChange(.goToHome)
                    return
                }
                self.presenter?.onStateChange(.goToLoginPref)
            })
            
        }
    }
}
