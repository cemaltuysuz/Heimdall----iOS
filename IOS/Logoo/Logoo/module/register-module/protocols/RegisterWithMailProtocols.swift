//
//  RegisterWithMailProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 3.02.2022.
//

import Foundation
import UIKit

protocol ViewToPresenterRegisterMail {
    var view:PresenterToViewRegisterMail? {get set}
    var interactor:PresenterToInteractorRegisterMail? {get set}
    
    func getRegisterMailSteps()
    func getRegisterGoogleSteps()
    
    func setUserImage(image:UIImage)
    func setUserInfo(username:String,userMail:String,userPassword:String)
    func setUserBirthDay(date:String)
    func setUserGender(gender:GenderType)
    
    func setUserInfoForGoogleUsers()
    func createUserWithEmail()
}

protocol PresenterToInteractorRegisterMail {
    var presenter:InteractorToPresenterRegisterMail? {get set}
    
    func getRegisterMailSteps()
    func getRegisterGoogleSteps()
    
    func setUserImage(image:UIImage)
    func setUserInfo(username:String,userMail:String,userPassword:String)
    func setUserBirthDay(date:String)
    func setUserGender(gender:GenderType)
    
    func setUserInfoForGoogleUsers()
    func createUserWithEmail()
}

protocol InteractorToPresenterRegisterMail {
    func registerStepsToPresenter(steps:[UICollectionViewCell])
    
    func registerProgressVisibility(status:Bool)
    func registerFeedBack(response:ValidationResponse)
}

protocol PresenterToViewRegisterMail {
    func registerStepsToView(steps:[UICollectionViewCell])
    
    func registerProgressVisibility(status:Bool)
    func registerFeedBack(response:ValidationResponse)
}

protocol PresenterToRouterRegisterMail {
    static func createModule(ref:RegisterVC)
}
