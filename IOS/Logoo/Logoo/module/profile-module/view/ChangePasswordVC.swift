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
        screenDescriptionLabel.text = "Change_Password_Screen_Description".localized()
        currentPasswordTextField.placeholder = "Enter your current password".localized()
        okButtonOutlet.setTitle("Okey".localized(), for: .normal)
    }
    
    func createModule() {
        ChangePasswordRouter.createModule(ref: self)
    }
    @IBAction func okButton(_ sender: Any) {
        showCurtain()
    }
}

extension ChangePasswordVC : PresenterToViewChangePasswordProtocol {
    func onStateChange(state: ChangePasswordState) {
        switch state {
        case .CLEAR_CURTAIN:
            closeCurtain()
        case .CURTAIN:
            showCurtain()
        case .CHANGE_PASSWORD_SUCCESS:
            createAlertNotify(title: "Success".localized(), message: "The link was sent successfully. Check your inbox.".localized(), onCompletion: { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.navigationController?.popViewController(animated: true)
            })
        case .CHANGE_PASSWORD_FAIL( _):
            break
        }
    }
}

enum ChangePasswordState {
    case CLEAR_CURTAIN
    case CURTAIN
    case CHANGE_PASSWORD_SUCCESS
    case CHANGE_PASSWORD_FAIL(message:String)
}
