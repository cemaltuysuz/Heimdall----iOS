//
//  LoginInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 9.02.2022.
//

import Foundation
import FirebaseAuth
import DeviceKit
import FirebaseDatabase

class LoginInteractor : PresenterToInteractorLoginProtocol {
    var presenter: InteractorToPresenterLoginProtocol?
    
    func loginUser(mail: String, password: String) {
        Auth.auth().signIn(withEmail: mail,
                           password: password) { authResult, error in
         
            if let error = error {
                let resp = Resource<UserState>(status: .ERROR,
                                               data: nil,
                                               message: "Giriş Başarısız. \(error.localizedDescription)")
                self.presenter?.loginResponse(status: resp)
            }
            
            if let user = authResult?.user {
                self.loginLog(userId: user.uid)
                let resp = Resource<UserState>(status: .SUCCESS,
                                               data: nil,
                                               message: nil)
                if user.isEmailVerified {
                    resp.data = .MAIL_ADRESS_CONFIRMED
                }else {
                    resp.data = .MAIL_ADRESS_NOT_CONFIRMED
                }
                self.presenter?.loginResponse(status: resp)
            }
        }
    }
    
    private func loginLog(userId:String){
        let dbRef = Database.database().reference()
        let logObject = [
            "userLoginTime"     : timeInSeconds,
            "deviceModel"       : Device.current.name ?? "unfounded",
            "deviceVersion"     : Device.current.systemVersion ?? "unfounded",
            "operatingSystem"   : "IOS"
        ] as [String : Any]
        
        let loginLogRef = dbRef.child("login-log").child(userId).child(UUID().uuidString)
        loginLogRef.setValue(logObject)
    }

}
