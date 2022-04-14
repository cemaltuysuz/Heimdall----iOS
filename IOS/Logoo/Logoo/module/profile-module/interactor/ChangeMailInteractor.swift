//
//  ChangeMailInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 5.04.2022.
//

import Foundation
import FirebaseAuth

class ChangeMailInteractor : PresenterToInteractorChangeMailProtocol {
    
    var presenter: InteractorToPresenterChangeMailProtocol?
    
    func reAuthRequest(currentPassword: String) {
        presenter?.onStateChange(state: .CURTAIN)
        
        if let user = Auth.auth().currentUser, let mail = user.email {
            let credential = EmailAuthProvider.credential(withEmail: mail, password: currentPassword)
            user.reauthenticate(with: credential, completion: {(result,error) in
                if let error = error {
                    print(error)
                    if let type = AuthErrorCode(rawValue: error._code) {
                        print(type.rawValue)
                        
                        switch type {
                        case .wrongPassword:
                            self.presenter?.onStateChange(state: .RE_AUTH_FAIL(message: "Wrong Password".localized()))
                            break
                        case .tooManyRequests:
                            self.presenter?.onStateChange(state: .RE_AUTH_FAIL(message: "The request was denied because the trial limit was exceeded. Try again later.".localized()))
                            break
                        default:
                            self.presenter?.onStateChange(state: .RE_AUTH_FAIL(message: "An error occurred while changing the password. Try again later.".localized()))
                        }
                    }
                    return
                }
                // Success
                self.presenter?.onStateChange(state: .SUCCESS_RE_AUTH(oldMail: mail))
            })
        }
    }
    
    func doChangeMail(mail: String) {
        if let user = Auth.auth().currentUser {
            user.sendEmailVerification(beforeUpdatingEmail: mail, completion: {error in
                if let error = error {
                    print(error)
                    self.presenter?.onStateChange(
                        state: .CHANGE_MAIL_FAIL(message: "An error occurred. Try again later.".localized())
                    )
                    return
                }
                self.presenter?.onStateChange(state: .SUCCESS_MAIL_CHANGE) // sended verification link
            })
        }
    }
}
