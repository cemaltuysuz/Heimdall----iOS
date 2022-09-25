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
    
    func onStateChange(state: InterestsState) {
        view?.onStateChange(state: state)
    }
    
    func getInterests(_ pageLimit:Int) {
        interactor?.getInterests(pageLimit)
    }
    
    func getUserInterests() {
        interactor?.getUserInterests()
    }
    
    func saveInterests(list: [Interest]) {
        interactor?.saveInterests(list: list)
    }
    
    func searchInterest(searchText: String) {
        interactor?.searchInterest(searchText: searchText)
    }
    
    func deleteInterest(_ interestID: String) {
        interactor?.deleteInterest(interestID)
    }

    func resetPagination() {
        interactor?.resetPagination()
    }
}
