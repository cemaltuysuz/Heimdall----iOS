//
//  ChangeMailVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 5.04.2022.
//

import UIKit

class ChangeMailVC: BaseVC {
    
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var screenDescriptionLabel: UILabel!
    @IBOutlet weak var newMailAdressTextField: LGTextField!
    @IBOutlet weak var currentPasswordTextField: LGTextField!
    @IBOutlet weak var okButtonOutlet: UIButton!
    var presenter : ViewToPresenterChangeMailProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        createModule()
    }
    
    func configureUI(){
        screenTitleLabel.text = "Change Mail".localized()
        screenDescriptionLabel.text = "A verification link will be sent to your new e-mail address. You will not be able to log in until your account has been approved.".localized()
        okButtonOutlet.setTitle("Okey".localized(), for: .normal)
        newMailAdressTextField.placeholder = "Enter your new mail adress".localized()
        currentPasswordTextField.placeholder = "Enter your current password".localized()
    }
    
    func createModule() {
        ChangeMailRouter.createModule(ref: self)
    }
    @IBAction func okButtonAction(_ sender: Any) {
    }
}

extension ChangeMailVC : PresenterToViewChangeMailProtocol {
    func onStateChange(state: ChangeMailState) {
        
    }
}

enum ChangeMailState {
    case CLEAR_CURTAIN
    case CURTAIN
    case CHANGE_PASSWORD_SUCCESS
    case CHANGE_PASSWORD_FAIL(message:String)
}
