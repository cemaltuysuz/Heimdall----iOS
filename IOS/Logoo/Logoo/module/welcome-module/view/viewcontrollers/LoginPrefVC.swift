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

class LoginPrefVC: BaseVC {

    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var signInWithGoogleButtonOutlet: UIButton!
    @IBOutlet weak var registerButtonOutlet: UIButton!
    
    var presenter : ViewToPresenterLoginPref?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        LogInPrefRouter.createModule(ref: self)
    }
    
    func configureUI(){
        loginButtonOutlet.setTitle("Login".localized(), for: .normal)
        signInWithGoogleButtonOutlet.setTitle("Sign In With Google".localized(), for: .normal)
        registerButtonOutlet.setTitle("Don't have an account yet? Register".localized(), for: .normal)
    }

    @IBAction func toLoginButton(_ sender: Any) {
        let vc = LoginVC.instantiate(from: .Welcome)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func registerWithMail(_ sender: Any) {
        let vc = RegisterVC.instantiate(from: .Welcome)
        vc.registerType = RegisterType.REGISTER_WITH_MAIL
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func googleSignInButtonAction(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
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
            self.showCurtain()
        }
    }
}

extension LoginPrefVC : PresenterToViewLoginPref {
    func logInResponse(status: Status, userState:UserState) {
        closeCurtain()
        if status == .SUCCESS {
            if userState == .GOOGLE_USER_CONFIRMED {
                let vc = CustomTabBarController.instantiate(from: .Main)
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
            }
            else if userState == .GOOGLE_USER_MISSING_INFORMATION {
                
                createBasicAlert(title: "Welcome".localized(),
                                 message: "Welcome to Heimdall. Missing information has been detected in your subscription. Do you want complete informations ?".localized(),
                                 okTitle: "Complete".localized(),
                                 onCompletion: {action in
                    switch action {
                    case .CONFIRM:
                        let vc = RegisterVC.instantiate(from: .Welcome)
                        vc.registerType = RegisterType.REGISTER_WITH_GOOGLE
                        self.navigationController?.pushViewController(vc, animated: true)
                        break
                    case .DISMISS:
                        let vc = CustomTabBarController.instantiate(from: .Main)
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                        break
                    }
                })
            }
            
        }else {
            createAlertNotify(title: "Error".localized(),
                              message: "Something went wrong.".localized())
        }
    }
}
