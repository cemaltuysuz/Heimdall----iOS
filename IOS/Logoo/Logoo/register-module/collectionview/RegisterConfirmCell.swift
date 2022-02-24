//
//  RegisterConfirmCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.02.2022.
//

import UIKit
import Lottie

class RegisterConfirmCell: UICollectionViewCell, RegisterProtocol {
    @IBOutlet weak var animContainer: UIView!
    private var anim:AnimationView?
    
    func validate() -> ValidationResponse {
        return ValidationResponse(status: true, message: "Success")
    }
    
    func initialize() {
        anim = AnimationView(name: "mail_sended")
        anim!.frame = animContainer.bounds
        anim!.animationSpeed = 1
        anim!.loopMode = .playOnce
        anim!.play()
        animContainer.addSubview(anim!)
    }
}
