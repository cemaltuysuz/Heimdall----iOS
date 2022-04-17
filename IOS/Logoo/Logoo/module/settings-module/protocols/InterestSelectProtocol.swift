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
    func saveInterests(list:[String])
    func searchInterest(searchText:String)
}

protocol PresenterToInteractorInterestSelectProtocol {
    var presenter: InteractorToPresenterInterestSelectProtocol? {get set}
    
    func getInterests()
    func saveInterests(list:[String])
    func searchInterest(searchText:String)
}

protocol InteractorToPresenterInterestSelectProtocol {
    func userAlreadyHobbies(alreadyList:[String])
    func allHobies(hobbyList:[InterestSelectionModel])
    
    func indicatorVisibility(status:Bool)
    func saveInterestsResponse(resp:Resource<Any>)
}

protocol PresenterToViewInterestSelectProtocol {
    
    func userAlreadyHobbies(alreadyList:[String])
    func allHobies(hobbyList:[InterestSelectionModel])
    
    func indicatorVisibility(status:Bool)
    func saveInterestsResponse(resp:Resource<Any>)
}

protocol PresenterToRouterInterestSelectProtocol {
    static func createModule(ref:SelectInterestVC)
}
