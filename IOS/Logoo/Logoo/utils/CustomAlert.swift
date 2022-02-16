//
//  CustomAlert.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.02.2022.
//

import Foundation
import UIKit
import Lottie

class CustomAlert {
    struct AlertValues {
        static let backgroundAlphaTo : CGFloat = 0.6
    }
    
    private var myTargetView : UIView?
    private var anim:AnimationView?
    
    private let backgroundView:UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        return backgroundView
    }()
    
    private let alertView:UIView = {
       let alert = UIView()
        alert.backgroundColor = .white
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 12
        return alert
    }()
    
    func showAlert (with title:String,
                    message:String,
                    viewController:UIViewController){
        guard let targetView = viewController.view else {
            return
        }
        myTargetView = targetView
        
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        
        // AlertView Design
        let alertWidth = targetView.frame.size.width-80
        let alertHeight = CGFloat(300)
        alertView.frame = CGRect(x: (targetView.center.x - (alertWidth / 2) ),
                                 y: targetView.center.y - (alertHeight / 2),
                                 width: alertWidth,
                                 height: alertHeight)
        targetView.addSubview(alertView)
        
        // Title Label Design
        let closeButtonWidth  = 30
        let closeButtonHeight = 30
        let closeButtonMargin = 10
        
        let closeButton = UIButton(type: .close)
        closeButton.frame = CGRect(x: Int(alertWidth) - (closeButtonWidth + closeButtonMargin), // + 10 is like margin
                                   y: closeButtonMargin ,
                                width: closeButtonWidth,
                                height: closeButtonHeight)
        
        closeButton.backgroundColor = .white
        closeButton.tintColor = UIColor(named: "black700")
        closeButton.addTarget(self,
                         action: #selector(self.dismissAlert),
                         for: .touchUpInside)
        alertView.addSubview(closeButton)
        
        anim = AnimationView(name: "loading")
        let animWidth = 200
        anim!.frame = CGRect(x: (Int(alertWidth) / 2) - (animWidth / 2),
                             y: ((Int(alertHeight) / 2) - (animWidth / 2)) - 20, // - 10 is Margin for Bottom
                             width: animWidth,
                             height: animWidth)
        
        // Ok Button
        let button = UILabel(frame: CGRect( x: 0,
                                             y: alertView.frame.size.height-50,
                                             width: alertView.frame.size.width,
                                             height: 50))
        button.text = message
        button.textColor = .black
        button.textAlignment = .center
        alertView.addSubview(button)
        
        UIView.animate(withDuration: 0.25,
                       animations: {
            self.backgroundView.alpha = AlertValues.backgroundAlphaTo
        }, completion: { done in
                UIView.animate(withDuration: 0.25, animations: {

                    self.alertView.center = targetView.center
                    self.anim!.animationSpeed = 1
                    self.anim!.loopMode = .loop
                    self.anim!.play()
                    self.alertView.addSubview(self.anim!)
                })

            
        })
    }
    
    @objc func dismissAlert(){
        guard let targetView = myTargetView else {
            return
        }
        
        UIView.animate(withDuration: 0.25,
                       animations: {
            self.alertView.frame = CGRect(x: 40,
                                     y: targetView.frame.size.height,
                                     width: targetView.frame.width-80,
                                     height: 300)
        }, completion: { done in
            if done {
                UIView.animate(withDuration: 0.25, animations: {
                    self.backgroundView.alpha = 0
                    
                },completion: { done in
                    self.anim?.stop()
                    self.alertView.removeFromSuperview()
                    self.backgroundView.removeFromSuperview()
                    
                })
            }
            
        })
    }
}
