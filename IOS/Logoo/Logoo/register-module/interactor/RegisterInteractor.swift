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
    
    func getRegisterSteps() {
        var steps = [UICollectionViewCell]()
            
        steps.append(RegisterPhotoPickCell())
        steps.append(RegisterInformationCell())
        steps.append(RegisterBirthDayCell())
        steps.append(RegisterGenderCell())
        steps.append(RegisterOTPCell())
        
        presenter?.registerStepsToPresenter(steps: steps)
    }
    
    
}
