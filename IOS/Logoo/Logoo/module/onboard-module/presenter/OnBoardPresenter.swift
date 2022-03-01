//
//  OnBoardPresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import Foundation

class OnBoardPresenter : InteractorToPresenterOnBoardProtocol, ViewToPresenterOnBoardProtocol {
    
    var view: PresenterToViewOnBoardProtocol?
    var interactor: PresenterToInteractorOnBoardProtocol?
   
    func getOnBoardList() {
        interactor?.getOnBoardList()
    }
    
    func onBoardListToPresenter(onBoardList: [OnBoard]) {
        view?.onBoardListToView(onBoardList: onBoardList)
    }
}
