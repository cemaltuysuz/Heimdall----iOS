//
//  OnBoardProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import Foundation

protocol ViewToPresenterOnBoardProtocol {
    var view:PresenterToViewOnBoardProtocol? {get set}
    var interactor:PresenterToInteractorOnBoardProtocol? {get set}
    
    func getOnBoardList()
}

protocol PresenterToInteractorOnBoardProtocol {
    var presenter:InteractorToPresenterOnBoardProtocol? {get set}
    
    func getOnBoardList()
}

protocol InteractorToPresenterOnBoardProtocol {
    func onBoardListToPresenter(onBoardList:[OnBoard])
}

protocol PresenterToViewOnBoardProtocol {
    func onBoardListToView(onBoardList:[OnBoard])
}

protocol PresenterToRouterOnBoardProtocol {
    static func createModule(ref:OnBoardVC)
}
