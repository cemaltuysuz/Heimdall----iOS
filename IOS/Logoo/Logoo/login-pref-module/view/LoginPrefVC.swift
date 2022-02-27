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
    
    @IBAction func registerWithMail(_ sender: Any) {
        performSegue(withIdentifier: LoginPrefVCSegues
                        .LoginPrefToRegister
                        .rawValue, sender: RegisterType.REGISTER_WITH_MAIL)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == LoginPrefVCSegues.LoginPrefToRegister.rawValue {
            if let type = sender as? RegisterType {
                let targetVC = segue.destination as! RegisterVC
                targetVC.registerType = type
            }
        }
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
    func logInResponse(status: Status, userState:UserState) {
        if status == .SUCCESS {
            if userState == .GOOGLE_USER_CONFIRMED {
                performSegue(withIdentifier: LoginPrefVCSegues
                                .LoginPrefToHome
                                .rawValue, sender: nil)
            }
            else if userState == .GOOGLE_USER_MISSING_INFORMATION {
                performSegue(withIdentifier: LoginPrefVCSegues
                                .LoginPrefToRegister
                                .rawValue, sender: RegisterType.REGISTER_WITH_GOOGLE)
            }

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
    case LoginPrefToRegister = "loginPrefToRegister"
}
