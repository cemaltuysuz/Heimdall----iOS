//
//  RegisterProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 11.04.2022.
//

import Foundation
import UIKit

protocol ViewToPresenterRegister {
    var view:PresenterToViewRegister? {get set}
    var interactor:PresenterToInteractorRegister? {get set}
    
    func getRegisterMailSteps()
    func getRegisterGoogleSteps()
    
    func setUserImage(image:UIImage)
    func setUserInfo(username:String,userMail:String,userPassword:String)
    func setUserBirthDay(date:String)
    func setUserGender(gender:GenderType)
    
    func setUserInfoForGoogleUsers()
    func createUserWithEmail()
}

protocol PresenterToInteractorRegister {
    var presenter:InteractorToPresenterRegister? {get set}
    
    func getRegisterMailSteps()
    func getRegisterGoogleSteps()
    
    func setUserImage(image:UIImage)
    func setUserInfo(username:String,userMail:String,userPassword:String)
    func setUserBirthDay(date:String)
    func setUserGender(gender:GenderType)
    
    func setUserInfoForGoogleUsers()
    func createUserWithEmail()
}

protocol InteractorToPresenterRegister {
    func registerStepsToPresenter(steps:[RegisterCellType])
    
    func registerProgressVisibility(status:Bool)
    func registerFeedBack(response:ValidationResponse)
}

protocol PresenterToViewRegister {
    func registerStepsToView(steps:[RegisterCellType])
    
    func registerProgressVisibility(status:Bool)
    func registerFeedBack(response:ValidationResponse)
}

protocol PresenterToRouterRegister {
    static func createModule(ref:RegisterVC)
}
