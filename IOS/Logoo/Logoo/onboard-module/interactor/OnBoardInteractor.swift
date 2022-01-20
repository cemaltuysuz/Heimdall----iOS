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
        
        onBoardList.append(OnBoard(image: UIImage(named: "onboard1")!, title: "YENI INSANLAR", description: "Logoo ile farklı konumlardaki farklı insanlar ile tanışabilirsin !"))
        onBoardList.append(OnBoard(image: UIImage(named: "onboard2")!, title: "OZGUR ANONIMLIK", description: "Logoo ile istediğin zaman anonim olabilirsin."))
        onBoardList.append(OnBoard(image: UIImage(named: "onboard3")!, title: "DUNYAYA ACIL", description: "Pasaport sistemi ile global çapta ücretsiz bir keşfe çıkabilirsin."))
        
        presenter?.onBoardListToPresenter(onBoardList: onBoardList)

    }
    
}
