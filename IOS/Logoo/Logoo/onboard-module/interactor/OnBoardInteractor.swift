//
//  OnBoardInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import Foundation
import UIKit

class OnBoardInteractor : PresenterToInteractorOnBoardProtocol {
    var presenter: InteractorToPresenterOnBoardProtocol?
    
    func getOnBoardList() {
        var onBoardList = [OnBoard]()
        
        onBoardList.append(OnBoard(image: UIImage(named: "onboard1")!, title: "baslik 1", description: "aciklama1"))
        onBoardList.append(OnBoard(image: UIImage(named: "onboard2")!, title: "baslik 2", description: "aciklama2"))
        onBoardList.append(OnBoard(image: UIImage(named: "onboard3")!, title: "baslik 3", description: "aciklama3"))
        
        presenter?.onBoardListToPresenter(onBoardList: onBoardList)

    }
    
}
