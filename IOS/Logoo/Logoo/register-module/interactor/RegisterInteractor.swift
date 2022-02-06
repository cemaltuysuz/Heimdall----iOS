//
//  RegisterInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 3.02.2022.
//

import Foundation
import UIKit

class RegisterInteractor : PresenterToInteractorRegisterMail{
    var presenter: InteractorToPresenterRegisterMail?
    
    private var userImage:UIImage?
    private var userName:String?
    private var userMail:String?
    private var userPassword:String?
    private var userBirthDay:String?
    private var userGender:GenderType?
    
    
    func getRegisterSteps() {
        var steps = [UICollectionViewCell]()
            
        steps.append(RegisterPhotoPickCell())
        steps.append(RegisterInformationCell())
        steps.append(RegisterBirthDayCell())
        steps.append(RegisterGenderCell())
        steps.append(RegisterOTPCell())
        
        presenter?.registerStepsToPresenter(steps: steps)
    }
    
    func setUserImage(image: UIImage) {
        self.userImage = image
        print("image geldi")
    }
    
    func setUserInfo(username: String, userMail: String, userPassword: String) {
        print("*********")
        print(username)
        print(userMail)
        print(userPassword)
        self.userName = username
        self.userMail = userMail
        self.userPassword = userPassword
    }
    
    func setUserBirthDay(date: String) {
        print("****")
        print(date)
        self.userBirthDay = date
    }
    
    func setUserGender(gender: GenderType) {
        print("*******")
        print(gender.rawValue)
        self.userGender = gender
    }
    
    
}
