//
//  LoginPrefProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 17.02.2022.
//
import Foundation
import FirebaseAuth

protocol ViewToPresenterLoginPref {
    var view:PresenterToViewLoginPref? {get set}
    var interactor:PresenterToInteractorLoginPref? {get set}
    
    func logInWithGoogle(credential:AuthCredential)
}

protocol PresenterToInteractorLoginPref {
    var presenter:InteractorToPresenterLoginPref? {get set}
    func logInWithGoogle(credential:AuthCredential)
}

protocol InteractorToPresenterLoginPref {
    func logInResponse(status:Status)
}

protocol PresenterToViewLoginPref {
    func logInResponse(status:Status)
}

protocol PresenterToRouterLoginPref {
    static func createModule(ref:LoginPrefVC)
}
