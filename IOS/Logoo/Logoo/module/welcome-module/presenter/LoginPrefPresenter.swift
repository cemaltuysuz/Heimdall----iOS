//
//  LoginPrefPresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 17.02.2022.
//

import Foundation
import FirebaseAuth

class LoginPrefPresenter : ViewToPresenterLoginPref, InteractorToPresenterLoginPref {
    var view: PresenterToViewLoginPref?
    var interactor: PresenterToInteractorLoginPref?
        
    func logInWithGoogle(credential: AuthCredential) {
        interactor?.logInWithGoogle(credential: credential)
    }
    
    func logInResponse(status: Status,userState:UserState) {
        view?.logInResponse(status: status, userState: userState)
    }
}
