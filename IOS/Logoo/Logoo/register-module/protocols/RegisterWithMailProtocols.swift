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
    
    func getRegisterSteps()
    
    func setUserImage(image:UIImage)
    func setUserInfo(username:String,userMail:String,userPassword:String)
    func setUserBirthDay(date:String)
    func setUserGender(gender:GenderType)
    
    func createUser()
}

protocol PresenterToInteractorRegisterMail {
    var presenter:InteractorToPresenterRegisterMail? {get set}
    
    func getRegisterSteps()
    func setUserImage(image:UIImage)
    func setUserInfo(username:String,userMail:String,userPassword:String)
    func setUserBirthDay(date:String)
    func setUserGender(gender:GenderType)
    
    func createUser()
}

protocol InteractorToPresenterRegisterMail {
    func registerStepsToPresenter(steps:[UICollectionViewCell])
    
    func registerProgressVisibility(status:Bool)
}

protocol PresenterToViewRegisterMail {
    func registerStepsToView(steps:[UICollectionViewCell])
    func registerProgressVisibility(status:Bool)
}

protocol PresenterToRouterRegisterMail {
    static func createModule(ref:RegisterVC)
}
