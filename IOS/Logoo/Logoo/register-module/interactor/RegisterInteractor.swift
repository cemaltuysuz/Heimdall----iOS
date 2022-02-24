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

class RegisterInteractor : PresenterToInteractorRegisterMail{
    
    var presenter: InteractorToPresenterRegisterMail?
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
    
    
    func getRegisterSteps() {
        var steps = [UICollectionViewCell]()
            
        steps.append(RegisterPhotoChooseCell())
        steps.append(RegisterInformationCell())
        steps.append(RegisterBirthDayCell())
        steps.append(RegisterGenderCell())
        steps.append(RegisterConfirmCell())
        
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
    
    func createUser() {
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

                let userRef = self.fireStoreDB.collection("users").document(user!.user.uid)
                // Kullanıcı kaydı için gerekli Dic nesnesini oluşturuyorum.
                let userObject = [
                    "userId"            : user!.user.uid,
                    "username"          : self.userName!,
                    "userMail"          : self.userMail!,
                    "userPhotoUrl"      : "",
                    "userGender"        : self.userGender!.rawValue,
                    "userBirthDay"      : self.userBirthDay!,
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
                        self.presenter?.registerFeedBack(response: ValidationResponse(status: false, message: "Error writing user to database. \(err.localizedDescription)"))
                        self.presenter?.registerProgressVisibility(status: false)
                        return
                    }
                    
                    // I upload user's photo to storage
                    
                    var data = Data()
                    data = self.userImage!.jpegData(compressionQuality: 0.8)!
                    // I converted the photo into data.
                    
                    // I determine the path to the file where the photo will be uploaded and the name / type of the file.
                    let fileUUID = UUID().uuidString
                    let filePath = "profile/\(Auth.auth().currentUser!.uid)/\(fileUUID)"
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/jpg"
                    
                    // STARTED PHOTO UPLOAD
                    self.storageRef.child(filePath).putData(data, metadata: metaData){(meta,error) in
                        if let err = error {
                            print("Error upload user photo : \(err.localizedDescription)")
                            self.presenter?.registerProgressVisibility(status: false)
                            return
                        }
                        self.storageRef.child(filePath).downloadURL{(url,error) in
                            if let error = error {
                                print("Error when receive the user's profile photo url : \(error)")
                                self.presenter?.registerProgressVisibility(status: false)
                                return
                            }
                            if let ppUrl = url?.absoluteString {
                                userRef.updateData(["userPhotoUrl":ppUrl])
                                self.presenter?.registerProgressVisibility(status: false)
                                self.presenter?.registerFeedBack(response:
                                                                    ValidationResponse(status: true,
                                                                                       message:
                                                                                        self.userMail!))
                                self.presenter?.registerProgressVisibility(status: false)
                                self.sendEmailVerification()
                            }
                            
                        }
                    }
                    
                }
                
            }
       // REGISTER IS FINISHED
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
