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
    
    
}
