//
//  LoginInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 9.02.2022.
//

import Foundation
import FirebaseAuth

class LoginInteractor : PresenterToInteractorLoginProtocol {
    var presenter: InteractorToPresenterLoginProtocol?
    
    func loginUser(mail: String, password: String) {
        Auth.auth().signIn(withEmail: mail, password: password) { authResult, error in
         
            if let error = error {
                let resp = Resource<UserState>(status: .ERROR,
                                               data: nil,
                                               message: "Giriş Başarısız. \(error.localizedDescription)")
                self.presenter?.loginResponse(status: resp)
            }
            
            if let user = authResult?.user {
                let resp = Resource<UserState>(status: .SUCCESS, data: nil, message: nil)
                if user.isEmailVerified {
                    resp.data = .MAIL_ADRESS_CONFIRMED
                }else {
                    resp.data = .MAIL_ADRESS_NOT_CONFIRMED
                }
                
                self.presenter?.loginResponse(status: resp)
            }
        }
    }

}
