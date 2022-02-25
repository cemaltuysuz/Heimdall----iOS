//
//  RegisterPresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 3.02.2022.
//

import Foundation
import UIKit

class RegisterPresenter : InteractorToPresenterRegisterMail, ViewToPresenterRegisterMail {
    
    var view: PresenterToViewRegisterMail?
    var interactor: PresenterToInteractorRegisterMail?
    
    func setUserInfoForGoogleUsers() {
        interactor?.setUserInfoForGoogleUsers()
    }
    
    func createUserWithEmail() {
        interactor?.createUserWithEmail()
    }
    
    func registerStepsToPresenter(steps: [UICollectionViewCell]) {
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
    
    func setUserBirthDay(date: String) {
        interactor?.setUserBirthDay(date: date)
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
