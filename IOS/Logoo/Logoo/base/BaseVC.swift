//
//  BaseVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 3.04.2022.
//

import UIKit

class BaseVC: UIViewController {
    
    lazy var curtain: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = curtainAlpha
        return view
    }()
    
    lazy var indicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .medium
        indicator.color = .lightGray
        return indicator
    }()

    let curtainAlpha:CGFloat =  0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()}
    
    // MARK: - Basic Alert | Parameters -> Title, Message And Actiton
    func createBasicAlert(title:String,message:String,onCompletion: @escaping (BasicAlertActionType) -> Void){
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Okey".localized(), style: .default, handler: {_ in
            onCompletion(.CONFIRM)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: {_ in
            onCompletion(.DISMISS)
        })
        
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Basic Alert Sheet | Parameters -> Title, Message And Actiton
    func createBasicAlertSheet(title:String,message:String,onCompletion: @escaping (BasicAlertActionType) -> Void){
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .actionSheet)
        
        let okButton = UIAlertAction(title: "Okey".localized(), style: .default, handler: {_ in
            onCompletion(.CONFIRM)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: {_ in
            onCompletion(.DISMISS)
        })
        
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true)
    }
    // MARK: - Show Curtain
    // This can be used if the user needs to wait while an action is being taken.
    
    func showCurtain(){
        curtain.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: curtain.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: curtain.centerYAnchor)
        ])
        view.addSubview(curtain)
    }
    
    // MARK: - Close Curtain
    func closeCurtain(){
        indicator.removeFromSuperview()
        curtain.removeFromSuperview()
    }
    
}

// MARK: - Basic Alert

enum BasicAlertActionType {
    case CONFIRM
    case DISMISS
}



