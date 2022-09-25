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
        
        onBoardList.append(
            OnBoard(
                image: UIImage(named: "onboard1")!,
                title: "New People".localized,
                description: "With Logoo, You meet different people in different locations !".localized))
        
        onBoardList.append(
            OnBoard(
                image: UIImage(named: "onboard2")!,
                title: "Free Anonymity".localized,
                description: "With logoo, you can make your profile anonymous at any time.".localized))
        
        onBoardList.append(
            OnBoard(
                image: UIImage(named: "onboard3")!,
                title: "Open To The World!".localized,
                description: "With the passport system, you can go on a global exploration.".localized))
        
        presenter?.onBoardListToPresenter(onBoardList: onBoardList)

    }
}
