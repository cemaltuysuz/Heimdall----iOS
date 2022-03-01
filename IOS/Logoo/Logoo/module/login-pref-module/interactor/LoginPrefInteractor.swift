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

class LoginPrefInteractor : PresenterToInteractorLoginPref {
    var presenter: InteractorToPresenterLoginPref?
    var fireStoreDB = Firestore.firestore()
    
    func logInWithGoogle(credential:AuthCredential) {
        
        Auth.auth().signIn(with: credential){ authResult, error in
            if let _ = error {
                self.presenter?.logInResponse(status: .ERROR,userState: .GOOGLE_ERROR)
                return
            }
            
            if let mail = authResult?.user.email, let uuid = authResult?.user.uid {
                
                
                let ref = Firestore.firestore().collection(FireCollections.USER_COLLECTION)
                FireStoreService<User>().getDocumentsByField(ref: ref,
                                                             getByField: "userMail",
                                                             getByValue: mail, onCompletion: {users,error in
                    
                    guard error == nil else {
                        return
                    }
                    
                    if let users = users, users.count > 0 {
                        // this mail is already registered system. No required retry register.
                        let user = users[0]!
                        
                        // I check any information of the user that absolutely needs to be filled.
                        // If it's not full I will redirect it back to the registration screen.
                        if let userBirthDay = user.userBirthDay, !userBirthDay.isEmpty {
                            print("KULLANICI VAR VE ONAYLANDI BILGISI TAM YANİ")
                            print("birth day : \(userBirthDay)")
                            self.presenter?.logInResponse(status: .SUCCESS, userState: .GOOGLE_USER_CONFIRMED)
                        }else {
                            self.presenter?.logInResponse(status: .SUCCESS, userState: .GOOGLE_USER_MISSING_INFORMATION)
                            print("KULLANICI ZATEN VAR AMA EKSIK BILGI TASIYOR")
                        }
                    }
                    else {
                        print("User is new.")
                        
                        // NEW REGISTER
                        
                        let userRef = self.fireStoreDB.collection("users").document(uuid)
                        let username = "User-\(randomStringWithLength(len: 5))"
                        
                        let userObjectt = User(userId: uuid,
                                               username: username,
                                               userMail: mail,
                                               userPhotoUrl: "",
                                               userGender: "",
                                               userBirthDay: "",
                                               userBio: "",
                                               userInterests: "",
                                               userLastSeen: "",
                                               userRegisterTime: "\(timeInSeconds())",
                                               isAnonymous: false,
                                               isOnline: false,
                                               isAllowTheGroupInvite: true,
                                               isAllowTheInboxInvite: true)
                        
                        FireStoreService<User>().pushDocument(userObjectt, ref: userRef, onCompletion: {boolean in

                            if let status = boolean {
                                if status {
                                    self.presenter?.logInResponse(status: .SUCCESS, userState: .GOOGLE_USER_MISSING_INFORMATION)
                                }else {
                                    self.presenter?.logInResponse(status: .ERROR, userState: .GOOGLE_ERROR)
                                }
                            }else {
                                self.presenter?.logInResponse(status: .ERROR, userState: .GOOGLE_ERROR)
                            }
                        })
                        
/**
 let userObject = [
             "userId"            : uuid,
             "username"          : "\(username)",
             "userMail"          : mail,
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
         self.presenter?.logInResponse(status: .ERROR,userState: .GOOGLE_ERROR)
         print("Error : \(err.localizedDescription)")
         self.presenter?.logInResponse(status: .ERROR,userState: .GOOGLE_ERROR)
         return
     }
     self.presenter?.logInResponse(status: .SUCCESS,userState: .GOOGLE_USER_MISSING_INFORMATION)
 }
 */
                        
                    }
                    
                })
            }
        }
    }
}
