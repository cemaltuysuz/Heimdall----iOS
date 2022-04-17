//
//  RegisterInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 3.02.2022.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage
import SwiftUI
import FirebaseFirestore

class RegisterInteractor : PresenterToInteractorRegister{
    
    var presenter: InteractorToPresenterRegister?
    var fireStoreDB = Firestore.firestore()
    var storageRef:StorageReference!
    
    init(){
        storageRef = Storage.storage().reference()
    }
    
    private var userImage:UIImage?
    private var userName:String?
    private var userMail:String?
    private var userPassword:String?
    private var userBirthDay:String?
    private var userGender:GenderType?
    

    func getRegisterMailSteps() {
        var steps = [RegisterCellType]()
            
        steps.append(.PHOTO_CHOOSE_CELL)
        steps.append(.INFORMATION_CELL)
        steps.append(.BIRTH_OF_DATE_CELL)
        steps.append(.GENDER_CELL)
        steps.append(.CONFIRM_CELL)
        
        presenter?.registerStepsToPresenter(steps: steps)
    }
    
    func getRegisterGoogleSteps() {
        var steps = [RegisterCellType]()
        
        steps.append(.PHOTO_CHOOSE_CELL)
        steps.append(.BIRTH_OF_DATE_CELL)
        steps.append(.GENDER_CELL)
        steps.append(.CONFIRM_CELL)
        
        presenter?.registerStepsToPresenter(steps: steps)
    }
    
    func setUserImage(image: UIImage) {
        self.userImage = image
    }
    
    func setUserInfo(username: String, userMail: String, userPassword: String) {
        self.userName = username
        self.userMail = userMail
        self.userPassword = userPassword
    }
    
    func setUserBirthDay(date: String) {
        self.userBirthDay = date
    }
    
    func setUserGender(gender: GenderType) {
        self.userGender = gender
    }
    
    
    func setUserInfoForGoogleUsers(){
        presenter?.registerProgressVisibility(status: true)
        let uuid = Auth.auth().currentUser!.uid
        let userRef = self.fireStoreDB.collection("users").document(uuid)

        /**
         A user logging in with Google already has information such as uuid, username and mail.
         So I'm just updating the missing information.
         */
        let userObject = [
            UserFieldType.USER_GENDER.rawValue        : self.userGender!.rawValue,
            UserFieldType.USER_BIRTHDAY.rawValue      : self.userBirthDay!,
                ] as [String:Any]

        // update user data
        userRef.updateData(userObject){err in
            if let err = err {
                self.presenter?.registerFeedBack(response: ValidationResponse(status: false, message: "Error writing user to database. \(err.localizedDescription)"))
                self.presenter?.registerProgressVisibility(status: false)
                return
            }
            self.uploadUserPhoto() // photo upload
            self.presenter?.registerFeedBack(response:
            ValidationResponse(status: true,
                               message:
                                nil))
            self.presenter?.registerProgressVisibility(status: false)
        }
    }
    
    func createUserWithEmail() {
        /**
         I show the indicator to the user to indicate that the registration process is in progress.
         */
        presenter?.registerProgressVisibility(status: true)
        
        // -- REGISTER IS STARTED --
        Auth.auth().createUser(
            withEmail: self.userMail!,
            password: self.userPassword!){ user, error in
                
                /**
                 *** TODO ()**
                 Kayıt oluşturulurken bir sorun oluşursa ;
                 - View kısmına bildir
                 - IndicatorView'i durdur
                 - return et
                 */
                if let err = error {
                    self.presenter?.registerFeedBack(response: ValidationResponse(status: false, message: "Something went wrong. \(err.localizedDescription)"))
                    self.presenter?.registerProgressVisibility(status: false)
                    return
                }

                let userRef = self.fireStoreDB.collection(FireStoreCollection.USER_COLLECTION).document(user!.user.uid)
                // Kullanıcı kaydı için gerekli Dic nesnesini oluşturuyorum.
                let userObjectt = User(userId: user!.user.uid,
                                       username: self.userName!,
                                       userMail: self.userMail!,
                                       userPhotoUrl: "",
                                       userGender: self.userGender!.rawValue,
                                       userBirthDay: self.userBirthDay!,
                                       userManifesto: "",
                                       userInterests: "",
                                       userLastSeen: "",
                                       userRegisterTime: "\(timeInSeconds())",
                                       isAnonymous: false,
                                       isOnline: false,
                                       isAllowTheGroupInvite: true,
                                       isAllowTheInboxInvite: true)
                
                /**
                 I process the user to firestore;
                 In this section, if the user is successfully processed into the database,
                 I will upload the user's profile picture to the storage area.
                 Then I will save it as a user profile picture with the ref value I got.
                 */
                FireStoreService.shared.pushDocument(userObjectt, ref: userRef, onCompletion: {boolean in

                    if let status = boolean {
                        if status {
                            self.uploadUserPhoto()
                            self.sendEmailVerification()
                            self.presenter?.registerFeedBack(response:
                            ValidationResponse(status: true,
                                               message:
                                                self.userMail!))
                        }else {
                            self.presenter?.registerFeedBack(response: ValidationResponse(status: false,
                                                                                          message: "Error writing user to database."))
                        }
                    }else {
                        self.presenter?.registerFeedBack(response: ValidationResponse(status: false,
                                                                                      message: "Error writing user to database."))
                    }
                })
            }
        }
    
    private func uploadUserPhoto(){
        if let userImage = userImage {
            if let uid = FirebaseAuthService.shared.getUUID() {
                let ref = Firestore.firestore().collection(FireStoreCollection.USER_COLLECTION).document(uid)
                let filePath = "\(FireStoragePath.USER_PHOTO)/\(uid)/\(UUID().uuidString)"
                
                FireStorageService.shared.pushPhoto(image: userImage, filePath: filePath, onCompletion: {(imageUrl:String?,error) in
                    guard let imageUrl = imageUrl else {
                        print(error ?? "not found error")
                        return
                    }
                    
                    let fields = [UserFieldType.USER_PHOTO.rawValue : imageUrl]
                    FireStoreService.shared.updateDocumentByField(ref: ref, fields: fields, onCompletion: {(response) in
                        if let status = response.status, status == true {
                            print("Photo upload is succeded.")
                        }else {
                            print("Photo upload is fail.")
                        }
                    })
                })
            }
        }
        self.presenter?.registerProgressVisibility(status: false)
    }
        
    /**
     I'm sending a confirmation email to the user. In order to do this, the user must be logged in according to firebase's rules. That's why I log in, send mail, then log out of the account.
     */
    private func sendEmailVerification(){
        if let mail = self.userMail, let password = self.userPassword {
            Auth.auth().signIn(withEmail: mail, password: password){(result,error) in
               if error != nil {
                   print("error when sign in user (register) \(error!.localizedDescription)")
                   return
               }
               let cUser = Auth.auth().currentUser
               cUser?.sendEmailVerification{error in
                   do{
                       try Auth.auth().signOut()
                   }catch{
                       print(error.localizedDescription)
                   }
               }
           }
        }
    }
}
