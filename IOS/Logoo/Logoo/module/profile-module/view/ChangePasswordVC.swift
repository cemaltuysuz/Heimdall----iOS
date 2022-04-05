//
//  ChangePasswordVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 5.04.2022.
//

import UIKit

class ChangePasswordVC: BaseVC {
    
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var screenDescriptionLabel: UILabel!
    @IBOutlet weak var currentPasswordTextField: LGTextField!
    @IBOutlet weak var okButtonOutlet: UIButton!
    
    
    var presenter:ViewToPresenterChangePasswordProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        createModule()
    }
    
    func configureUI(){
        screenTitleLabel.text = "Change Password".localized()
        screenDescriptionLabel.text = "We will send a link to your e-mail address for password change. You can change your password via the link.".localized()
        currentPasswordTextField.placeholder = "Enter your current password".localized()
        okButtonOutlet.setTitle("Okey".localized(), for: .normal)
    }
    
    func createModule() {
        ChangePasswordRouter.createModule(ref: self)
    }
    @IBAction func okButton(_ sender: Any) {
        
    }
}

extension ChangePasswordVC : PresenterToViewChangePasswordProtocol {
    func onStateChange(state: ChangePasswordState) {
        switch state {
        case .CLEAR_CURTAIN:
            <#code#>
        case .CURTAIN:
            <#code#>
        case .CHANGE_PASSWORD_SUCCESS:
            <#code#>
        case .CHANGE_PASSWORD_FAIL( _):
            <#code#>
        }
    }
}

enum ChangePasswordState {
    case CLEAR_CURTAIN
    case CURTAIN
    case CHANGE_PASSWORD_SUCCESS
    case CHANGE_PASSWORD_FAIL(message:String)
}
