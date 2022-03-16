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
                FirebaseLoggerService.shared.login_log()
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
                UDService.shared.setConfirmEmailTime(time: timeInSeconds()) // save time
                response.status = .SUCCESS
                self.presenter?.verificationLinkResponse(status: response)
            }
        }
    }
    
    func calculateRepeatTime() {
        // Confirm e-mail counter (Last seen)
        let lastDate = milliSecondToDate(milliseconds: UDService.shared.getConfirmEmailTime()) 
        let lastSeconds = UDService.shared.getConfirmEmailSecond()
        let currentDate = Date()
        
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.second], from: lastDate, to: currentDate)
        let diff = dateComponents.second
        let total = Int(lastSeconds) - diff!
        if total > 0 {
            presenter?.timeLimitCountinues(status: true, continuationTime: Int64(total))
        }
    }
    

}

