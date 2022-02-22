//
//  LoginPrefVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import GoogleSignIn
import Firebase
import UIKit
import FirebaseAuth

class LoginPrefVC: UIViewController {

    var presenter : ViewToPresenterLoginPref?
    override func viewDidLoad() {
        super.viewDidLoad()

        LogInPrefRouter.createModule(ref: self)
        
    }

    @IBAction func toLoginButton(_ sender: Any) {
        performSegue(withIdentifier: LoginPrefVCSegues
                        .LoginPrefToLogin
                        .rawValue, sender: nil)
    }
    @IBAction func googleSignInButtonAction(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in

          if let error = error {
              print("error : \(error.localizedDescription)")
            return
          }

          guard let authentication = user?.authentication,
            let idToken = authentication.idToken
          else {
            return
          }
          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)
            self.presenter?.logInWithGoogle(credential: credential)
        }
    }
}

extension LoginPrefVC : PresenterToViewLoginPref {
    func logInResponse(status: Status) {
        if status == .SUCCESS {
            performSegue(withIdentifier: LoginPrefVCSegues
                            .LoginPrefToHome
                            .rawValue, sender: nil)
        }else {
            let alert = UIAlertController(title: "Error".localized(),
                                          message: "Something went wrong.".localized(),
                                          preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: {_ in
                })
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        }
    }
}

enum LoginPrefVCSegues :String {
    case LoginPrefToLogin = "loginPrefToLogin"
    case LoginPrefToHome = "loginPrefToHome"
}
