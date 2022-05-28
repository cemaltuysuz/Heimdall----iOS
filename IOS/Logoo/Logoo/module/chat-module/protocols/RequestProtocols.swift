//
//  RequestProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.05.2022.
//

import Foundation

protocol ViewToPresenterRequestProtocol {
    
    var view:PresenterToViewRequestProtocol? {get set}
    var interactor:PresenterToInteractorRequestProtocol? {get set}
    
    func getTargetUserFromRequest(_ req:Request)
    func confirmRequest(_ req:Request)
    func rejectRequest(_ req:Request)
}

protocol PresenterToInteractorRequestProtocol {
    
    var presenter:InteractorToPresenterRequestProtocol? {get set}
    
    func getTargetUserFromRequest(_ req:Request)
    func confirmRequest(_ req:Request)
    func rejectRequest(_ req:Request)
}

protocol InteractorToPresenterRequestProtocol {
    
    func onStateChange(state:RequestState)
    func confirmRequest(_ req:Request)
    func rejectRequest(_ req:Request)
    
}

protocol PresenterToViewRequestProtocol {
    
    func onStateChange(state:RequestState)
    
}

protocol PresenterToRouterRequestProtocol {
    
    static func createModule(ref:RequestVC)
    
}
