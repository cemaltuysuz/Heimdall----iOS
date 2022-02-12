//
//  SelectInterestPresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 11.02.2022.
//

import Foundation

class SelectInterestPresenter : InteractorToPresenterInterestSelectProtocol, ViewToPresenterInterestSelectProtocol{
    
    var view: PresenterToViewInterestSelectProtocol?
    var interactor: PresenterToInteractorInterestSelectProtocol?
    
    func hobbies(hobbyList: [InterestSelectionModel], alreadyList: [String]) {
        view?.hobbies(hobbyList: hobbyList, alreadyList: alreadyList)
    }
    
    func getInterests(uuid: String) {
        interactor?.getInterests(uuid: uuid)
    }
}
