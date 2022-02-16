//
//  ResetPasswordInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.02.2022.
//

import Foundation
import FirebaseAuth

class ResetPasswordInteractor : PresenterToInteractorResetPasswordProtocol {
    var presenter: InteractorToPresenterResetPasswordProtocol?
    
    func sendResetLink(mail: String) {
        Auth.auth().sendPasswordReset(withEmail: mail){error in
            if let error = error {
                self.presenter?.sendLinkResponse(resp: .ERROR)
                print(error.localizedDescription)
            }else {
                self.presenter?.sendLinkResponse(resp: .SUCCESS)
            }
        }
    }
}
