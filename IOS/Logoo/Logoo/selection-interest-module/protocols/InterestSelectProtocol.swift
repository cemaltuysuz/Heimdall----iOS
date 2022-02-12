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
    
    func getInterests(uuid:String)
}

protocol PresenterToInteractorInterestSelectProtocol {
    var presenter: InteractorToPresenterInterestSelectProtocol? {get set}
    
    func getInterests(uuid:String)
}

protocol InteractorToPresenterInterestSelectProtocol {
    func hobbies(hobbyList:[String], alreadyList:[String])
}

protocol PresenterToViewInterestSelectProtocol {
    func hobbies(hobbyList:[String], alreadyList:[String])
}

protocol PresenterToRouterInterestSelectProtocol {
    static func createModule(ref:SelectInterestVC)
}
