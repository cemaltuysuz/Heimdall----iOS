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
    

    func userAlreadyHobbies(alreadyList: [String]) {
        view?.userAlreadyHobbies(alreadyList: alreadyList)
    }
    
    func allHobies(hobbyList: [InterestSelectionModel]) {
        view?.allHobies(hobbyList: hobbyList)
    }
    
    func searchInterest(searchText: String) {
        interactor?.searchInterest(searchText: searchText)
    }
    
    func getInterests() {
        interactor?.getInterests()
    }
    
    func indicatorVisibility(status: Bool) {
        view?.indicatorVisibility(status: status)
    }
    
    func saveInterestsResponse(resp: Resource<Any>) {
        view?.saveInterestsResponse(resp: resp)
    }
    
    func saveInterests(list: [String]) {
        interactor?.saveInterests(list: list)
    }
}
