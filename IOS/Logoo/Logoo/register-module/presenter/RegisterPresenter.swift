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
    
    func registerStepsToPresenter(steps: [UICollectionViewCell]) {
        view?.registerStepsToView(steps: steps)
    }
    func getRegisterSteps() {
        interactor?.getRegisterSteps()
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
    
    
}
