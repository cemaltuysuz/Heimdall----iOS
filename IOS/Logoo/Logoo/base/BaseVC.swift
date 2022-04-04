//
//  BaseVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 3.04.2022.
//

import UIKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func createBasicAlert(title:String,message:String,onCompletion: @escaping (BasicAlertActionType) -> Void){
        let alert = UIAlertController(title: "Change Password".localized(),
                                      message: "change_password_message".localized(),
                                      preferredStyle: .actionSheet)
        
        let okButton = UIAlertAction(title: "Okey".localized(), style: .default, handler: {_ in
            onCompletion(.CONFIRM)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: {_ in
            onCompletion(.DISMISS)
        })
        
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true, completion: {
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Basic Alert

enum BasicAlertActionType {
    case CONFIRM
    case DISMISS
}



