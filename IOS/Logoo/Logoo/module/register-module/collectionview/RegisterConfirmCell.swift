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
        resultMessageLabel.text = message!
        anim = AnimationView(name: animName!)
        anim!.frame = animContainer.bounds
        anim!.animationSpeed = 1
        anim!.loopMode = .playOnce
        anim!.play()
        animContainer.addSubview(anim!)
    }
}
