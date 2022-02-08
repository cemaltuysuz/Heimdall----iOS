//
//  RegisterOTPCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import UIKit
import Lottie

class RegisterOTPCell: UICollectionViewCell, RegisterProtocol {
    @IBOutlet weak var animContainer: UIView!
    private var anim:AnimationView?
    
    func validate() -> ValidationResponse {
        return ValidationResponse(status: true, message: "otp başarılı")
    }
    
    func initialize() {
        anim = AnimationView(name: "mail_sended")
        anim!.frame = animContainer.bounds
        anim!.animationSpeed = 1
        anim!.loopMode = .loop
        anim!.play()
        animContainer.addSubview(anim!)
    }
}
