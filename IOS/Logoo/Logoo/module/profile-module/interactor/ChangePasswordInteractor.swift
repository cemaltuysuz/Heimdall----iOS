//
//  ChangePasswordInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 5.04.2022.
//

import Foundation
import FirebaseAuth

class ChangePasswordInteractor : PresenterToInteractorChangePasswordProtocol {
    var presenter: InteractorToPresenterChangePasswordProtocol?
    
    func resetPasswordRequest(currentPassword: String,newPassword:String) {
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
                            self.presenter?.onStateChange(state: .CHANGE_PASSWORD_FAIL(message: "Wrong Password".localized()))
                            break
                        case .tooManyRequests:
                            self.presenter?.onStateChange(state: .CHANGE_PASSWORD_FAIL(message: "The request was denied because the trial limit was exceeded. Try again later.".localized()))
                            break
                        default:
                            self.presenter?.onStateChange(state: .CHANGE_PASSWORD_FAIL(message: "An error occurred while changing the password. Try again later.".localized()))
                        }
                    }
                    
                    return
                }
                
                user.updatePassword(to: newPassword, completion: {(error) in
                    if let error = error {
                        print(error)
                        self.presenter?.onStateChange(state: .CHANGE_PASSWORD_FAIL(message: "An error occurred while changing the password. Try again later.".localized()))
                    }
                    self.presenter?.onStateChange(state: .CHANGE_PASSWORD_SUCCESS)
                })
            })
        }else {
            presenter?.onStateChange(state: .CLEAR_CURTAIN)
            presenter?.onStateChange(state: .CHANGE_PASSWORD_FAIL(message: "Something went wrong".localized()))
        }
    }
}
