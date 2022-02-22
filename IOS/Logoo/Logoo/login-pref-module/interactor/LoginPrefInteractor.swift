//
//  LoginPrefInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 17.02.2022.
//

import Foundation
import FirebaseFirestore
import Firebase
import GoogleSignIn
import FirebaseAuth

class LoginPrefInteractor : PresenterToInteractorLoginPref{
    var presenter: InteractorToPresenterLoginPref?
    var fireStoreDB = Firestore.firestore()
    
    func logInWithGoogle(credential:AuthCredential) {
        
        Auth.auth().signIn(with: credential){ authResult, error in
            if let error = error {
                self.presenter?.logInResponse(status: .ERROR)
                return
            }
            
            if let mail = authResult?.user.email, let uuid = authResult?.user.uid {
                
                let userRef = self.fireStoreDB.collection("users").document(uuid)
                let username = "User-\(randomStringWithLength(len: 5))"
                let userObject = [
                            "userId"            : uuid,
                            "username"          : "\(username)",
                            "userMail"          : mail,
                            "userPhotoUrl"      : "",
                            "userGender"        : "",
                            "userBirthDay"      : "",
                            "userBio"           : "",
                            "userHobbies"       : "",
                            "userLastSeen"      : "",
                            "userRegisterTime"  : "\(timeInSeconds())",
                            "isAnonymous"       : false,
                            "isOnline"          : false,
                            "isAllowTheGroupInvite" : true,
                            "isAllowTheInboxInvite" : true
                            ] as [String:Any]
                        /**
                         I process the user to firestore;
                         In this section, if the user is successfully processed into the database,
                         I will upload the user's profile picture to the storage area.
                         Then I will save it as a user profile picture with the ref value I got.
                         */
                userRef.setData(userObject){err in
                    if let err = error {
                        self.presenter?.logInResponse(status: .ERROR)
                        print("Error : \(err.localizedDescription)")
                        self.presenter?.logInResponse(status: .ERROR)
                        return
                    }
                    self.presenter?.logInResponse(status: .SUCCESS)
                }
            }
        }
    }
}
