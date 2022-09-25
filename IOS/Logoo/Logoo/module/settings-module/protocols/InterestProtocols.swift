//
//  InterestsSelectProtocol.swift
//  Logoo
//
//  Created by cemal tüysüz on 11.02.2022.
//

import Foundation

protocol ViewToPresenterInterestSelectProtocol {
    var view: PresenterToViewInterestSelectProtocol? {get set}
    var interactor: PresenterToInteractorInterestSelectProtocol? {get set}
    
    func getInterests(_ pageLimit:Int)
    func getUserInterests()
    func saveInterests(list:[Interest])
    func searchInterest(searchText:String)
    func deleteInterest(_ interestID:String)
    func resetPagination()
}

protocol PresenterToInteractorInterestSelectProtocol {
    var presenter: InteractorToPresenterInterestSelectProtocol? {get set}
    
    func getUserInterests()
    func getInterests(_ pageLimit:Int)
    func saveInterests(list:[Interest])
    func searchInterest(searchText:String)
    func deleteInterest(_ interestID:String)
    func resetPagination()
}

protocol InteractorToPresenterInterestSelectProtocol {
    func onStateChange(state:InterestsState)
}

protocol PresenterToViewInterestSelectProtocol {
    func onStateChange(state:InterestsState)
}

protocol PresenterToRouterInterestSelectProtocol {
    static func createModule(ref:SelectInterestVC)
}
