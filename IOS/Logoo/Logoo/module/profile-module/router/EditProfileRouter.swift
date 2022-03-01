//
//  EditProfileRouter.swift
//  Logoo
//
//  Created by cemal tüysüz on 1.03.2022.
//

import Foundation

class EditProfileRouter : PresenterToRouterEditProfileProtocol {
    
    static func createModule(ref: EditProfileVC) {
        let p = EditProfilePresenter()
        ref.presenter = p
        ref.presenter?.view = ref
        ref.presenter?.interactor = EditProfileInteractor()
        ref.presenter?.interactor?.presenter = p
    }
}
