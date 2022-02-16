//
//  ResetPasswordVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.02.2022.
//

import UIKit

class ResetPasswordVC: UIViewController {
    var presenter:ViewToPresenterResetPasswordProtocol?
    
    @IBOutlet weak var resetMailErrorLabel: UILabel!
    @IBOutlet weak var resetMailTextField: UITextField!
    @IBOutlet weak var resetPasswordIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ResetPasswordRouter.createModule(ref: self)
        
    }
    @IBAction func sendResetLinkButton(_ sender: Any) {
        guard let mail = resetMailTextField.text, isValidMail(mail: mail) else {
            resetMailErrorLabel.text = "The e-mail address is not in the correct format."
            resetMailErrorLabel.isHidden = false
            return
        }
            resetMailErrorLabel.isHidden = true
            resetPasswordIndicator.startAnimating()
            presenter?.sendResetLink(mail: mail)

    }
}

extension ResetPasswordVC : PresenterToViewResetPasswordProtocol {
    func sendLinkResponse(resp: Status) {
        var alert:UIAlertController?
        resetPasswordIndicator.stopAnimating()
        if resp == .SUCCESS {
            alert = UIAlertController(title: "Successfully".localized(),
                                      message: "The connection was sent successfully. Check your inbox.".localized(),
                                      preferredStyle: .alert)
            alert!.addAction(
                UIAlertAction(title: "Close".localized(),
                              style: .cancel, handler: {_ in
                                  self.navigationController?.popViewController(animated: true)
           }))
            self.present(alert!, animated: true)
            
        }else {
            print("false")
            alert = UIAlertController(title: "Failed".localized(),
                                      message: "Something went wrong. Please check your e-mail address.".localized(),
                                      preferredStyle: .alert)
            alert!.addAction(
                UIAlertAction(title: "Close".localized(),
                              style: .cancel)
            )
            self.present(alert!, animated: true)
        }
    }

}
