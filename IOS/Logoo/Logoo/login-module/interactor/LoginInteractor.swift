//
//  LoginInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 9.02.2022.
//

import Foundation
import FirebaseAuth
import DeviceKit
import FirebaseFirestore

class LoginInteractor : PresenterToInteractorLoginProtocol {
    var presenter: InteractorToPresenterLoginProtocol?
    
    
    func loginUser(mail: String, password: String) {
        Auth.auth().signIn(withEmail: mail,
                           password: password) { authResult, error in
         
            if let error = error {
                let resp = Resource<UserState>(status: .ERROR,
                                               data: nil,
                                               message: "Login failed. \(error.localizedDescription)")
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
                    resp.message = user.email
                }
               self.presenter?.loginResponse(status: resp)
            }
        }
    }
    
    private func loginLog(userId:String){
        let dbRef = Firestore.firestore()
        let logObject = [
            "userLoginTime"     : timeInSeconds(),
            "deviceModel"       : Device.current.name ?? "unknow",
            "deviceVersion"     : Device.current.systemVersion ?? "unknow",
            "operatingSystem"   : "IOS"
        ] as [String : Any]
        
        let loginLogRef = dbRef
            .collection("login-log")
            .document(userId)
            .collection(UUID().uuidString)
        
        loginLogRef.addDocument(data: logObject)
    }
    
    func sendVerificationLink(mail: String) {
        if let user = Auth.auth().currentUser {
            user.sendEmailVerification{(error) in
                
                let response = Resource<Any>(status: nil, data: nil, message: nil)
                if let error = error {
                    
                    response.status = .ERROR
                    response.message = error.localizedDescription
                    self.presenter?.verificationLinkResponse(status: response)
                    
                    print("Error : \(error.localizedDescription)")
                    return
                }
                
                response.status = .SUCCESS
                self.presenter?.verificationLinkResponse(status: response)
            }
        }
    }

}

