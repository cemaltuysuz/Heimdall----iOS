//
//  SecurityVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 10.03.2022.
//

import UIKit

class SecurityVC: UIViewController {
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var visualView: UIView!
    
    
    var presenter:ViewToPresenterSecurityProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}


extension SecurityVC : PresenterToViewSecurityProtocol {
    
}
