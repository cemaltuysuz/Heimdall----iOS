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
    
    func getInterests()
    func saveInterests(list:[Interest])
    func searchInterest(searchText:String)
}

protocol PresenterToInteractorInterestSelectProtocol {
    var presenter: InteractorToPresenterInterestSelectProtocol? {get set}
    
    func getInterests()
    func saveInterests(list:[Interest])
    func searchInterest(searchText:String)
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
