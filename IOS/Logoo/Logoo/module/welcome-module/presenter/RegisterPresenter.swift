//
//  RegisterPresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 3.02.2022.
//

import Foundation
import UIKit

class RegisterPresenter : InteractorToPresenterRegister, ViewToPresenterRegister {
    
    var view: PresenterToViewRegister?
    var interactor: PresenterToInteractorRegister?
    
    func setUserInfoForGoogleUsers() {
        interactor?.setUserInfoForGoogleUsers()
    }
    
    func createUserWithEmail() {
        interactor?.createUserWithEmail()
    }
    
    func registerStepsToPresenter(steps: [RegisterCellType]) {
        view?.registerStepsToView(steps: steps)
    }

    func getRegisterMailSteps() {
        interactor?.getRegisterMailSteps()
    }
    
    func getRegisterGoogleSteps() {
        interactor?.getRegisterGoogleSteps()
    }
    
    func setUserImage(image: UIImage) {
        interactor?.setUserImage(image: image)
    }
    
    func setUserInfo(username: String, userMail: String, userPassword: String) {
        interactor?.setUserInfo(username: username, userMail: userMail, userPassword: userPassword)
    }
    
    func setUserBirthDay(birthDay: String) {
        interactor?.setUserBirthDay(birthDay: birthDay)
    }
    
    func setUserGender(gender: GenderType) {
        interactor?.setUserGender(gender: gender)
    }
    
    func registerProgressVisibility(status: Bool) {
        view?.registerProgressVisibility(status: status)
    }
    
    func registerFeedBack(response: ValidationResponse) {
        view?.registerFeedBack(response: response)
    }
    
}
