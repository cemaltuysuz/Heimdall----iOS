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
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    lazy var indicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.style = .large
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
    
    
    func createAlertNotify(title:String,message:String,onCompletion: @escaping () -> Void){
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .actionSheet)
        
        let okButton = UIAlertAction(title: "Okey".localized(), style: .default, handler: {_ in
            onCompletion()
        })
        
        alert.addAction(okButton)
        
        self.present(alert, animated: true)
    }

    
    // MARK: - Show Curtain
    // This can be used if the user needs to wait while an action is being taken.
    
    func showCurtain(){
        view.isUserInteractionEnabled = false
        navigationController?.navigationBar.isUserInteractionEnabled = false
        tabBarController?.tabBar.isUserInteractionEnabled = false
        
        curtain.addSubview(indicator)
        view.addSubview(curtain)
        
        NSLayoutConstraint.activate([
            curtain.topAnchor.constraint(equalTo: view.topAnchor),
            curtain.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            curtain.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            curtain.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            indicator.centerXAnchor.constraint(equalTo: curtain.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: curtain.centerYAnchor)
        ])
        curtain.alpha = 0
        UIView.animate(withDuration: curtainAlpha) {
            self.curtain.alpha = self.curtainAlpha
            self.indicator.startAnimating()
        }
    }
    
    // MARK: - Close Curtain
    func closeCurtain(){
        view.isUserInteractionEnabled = true
        navigationController?.navigationBar.isUserInteractionEnabled = true
        tabBarController?.tabBar.isUserInteractionEnabled = true
        
        indicator.removeFromSuperview()
        curtain.removeFromSuperview()
    }
    
}

// MARK: - Basic Alert

enum BasicAlertActionType {
    case CONFIRM
    case DISMISS
}



