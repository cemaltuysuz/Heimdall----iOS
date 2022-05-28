//
//  RequestPresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.05.2022.
//

import Foundation

class RequestPresenter : ViewToPresenterRequestProtocol, InteractorToPresenterRequestProtocol {
    
    var view: PresenterToViewRequestProtocol?
    var interactor: PresenterToInteractorRequestProtocol?

    func getTargetUserFromRequest(_ req: Request) {
        interactor?.getTargetUserFromRequest(req)
    }
    
    func onStateChange(state: RequestState) {
        view?.onStateChange(state: state)
    }
    
    func confirmRequest(_ req: Request) {
        interactor?.confirmRequest(req)
    }
    
    func rejectRequest(_ req: Request) {
        interactor?.rejectRequest(req)
    }
}
