//
//  RegisterConfirmCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.02.2022.
//

import UIKit
import Lottie

class RegisterConfirmCell: UICollectionViewCell {
    @IBOutlet weak var animContainer: UIView!
    @IBOutlet weak var resultMessageLabel: UILabel!
    private var anim:AnimationView?
    var animName:String?
    var message:String?

    func initialize() {
        if let anim = anim {
            anim.frame = animContainer.bounds
            anim.animationSpeed = 1
            anim.loopMode = .playOnce
            anim.play()
            animContainer.addSubview(anim)
        }
    }
}

extension RegisterConfirmCell : RegisterBindable, Registerable {
    func bind(_ viewController: RegisterVC) {
        resultMessageLabel.text = viewController.resultScreenMessage
        anim = AnimationView(name: viewController.resultScreenAnimName ?? "success")
        initialize()
    }
    
    func validate() -> ValidationResponse {
        return ValidationResponse(status: true)
    }
}
