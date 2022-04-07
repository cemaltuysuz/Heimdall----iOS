//
//  ProfileInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 7.04.2022.
//

import Foundation

class ProfileInteractor : PresenterToInteractorProfileProtocol {
    
    var presenter: InteractorToPresenterProfileProtocol?
    
    
    func loadPage() {
        getUser()
    }
    
    func getUser(){
        
    }
    
    
}
