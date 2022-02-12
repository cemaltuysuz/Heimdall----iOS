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
            
        steps.append(RegisterPhotoPickCell())
        steps.append(RegisterInformationCell())
        steps.append(RegisterBirthDayCell())
        steps.append(RegisterGenderCell())
        steps.append(RegisterOTPCell())
        
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
         Kayıt işlemlerinin sürdüğünü belirtmek adına kullanıcıya indicator gösteriyorum.
         */
        presenter?.registerProgressVisibility(status: true)
        
        // -- KAYIT İŞLEMİ BAŞLADI --
        Auth.auth().createUser(
            withEmail: self.userMail!,
            password: self.userPassword!){ user, error in
                
                /**
                 Kayıt oluşturulurken bir sorun oluşursa ;
                 - View kısmına bildir
                 - IndicatorView'i durdur
                 - return et
                 */
                if let err = error {
                    self.presenter?.registerFeedBack(response: ValidationResponse(status: false, message: "Bir sorun oluştu. \(err.localizedDescription)"))
                    self.presenter?.registerProgressVisibility(status: false)
                    return
                }
                /**
                  Kullanıcıyı firestore kısmına kayıt etmek için bir veritabanı referansı oluşturuyorum
                 */
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
                    "isAnonymous"       : "false",
                    "isOnline"          : "false",
                    "isAllowTheGroupInvite" : "true",
                    "isAllowTheInboxInvite" : "true"
                    
                    
                        ] as [String:Any]
                /**
                 Kullanıcıyı firestore'a işliyorum ;
                 Bu kısımda eğer kullanıcı veritabanına başarılı bir şekilde işlenirse kullanıcının profil resmini storage alanına upload edeceğim.
                 Sonrasında aldığım ref değeri ile bunu kullanıcı profil resmi olarak kayıt edeceğim.
                 */
                userRef.setData(userObject){err in
                    if let err = error {
                        self.presenter?.registerFeedBack(response: ValidationResponse(status: false, message: "Error writing user to database. \(err.localizedDescription)"))
                        self.presenter?.registerProgressVisibility(status: false)
                        return
                    }
                    
                    // Kullanıcının fotoğrafını storage kısmına kayıt ediyorum.
                    
                    var data = Data()
                    data = self.userImage!.jpegData(compressionQuality: 0.8)! // Fotoğrafı data haline getirdim.
                    
                    // Fotoğrafın yükleneceği dosya yolunu ve dosyanın ismi / tipini belirliyorum.
                    let fileUUID = UUID().uuidString
                    let filePath = "profile/\(Auth.auth().currentUser!.uid)/\(fileUUID)"
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/jpg"
                    
                    // fotoğraf yükleme işlemini başlatıyorum.
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
       // KAYIT İŞLEMİ BİTTİ
            }
    /**
     Kullanıcıya onay e postası gonderiyorum. Bunu yapabilmek için firebase'in kurallarına göre kullanıcının giriş yapmış olması gerekiyor. Bu yuzden giriş yapıyor, mail gonderiyor ardından hesaptan çıkış yapıyorum.
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

/**
 
 
 var data = Data()
 data = self.userImage!.jpegData(compressionQuality: 0.8)! // Fotoğrafı data haline getirdim.
 
 // Fotoğrafın yükleneceği dosya yolunu ve dosyanın ismi / tipini belirliyorum.
 let fileUUID = UUID().uuidString
 let filePath = "profile/\(Auth.auth().currentUser!.uid)/\(fileUUID)"
 let metaData = StorageMetadata()
 metaData.contentType = "image/jpg"
 
 // fotoğraf yükleme işlemini başlatıyorum.
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
             rgRef.child("userPhotoUrl").setValue(ppUrl)
             self.presenter?.registerProgressVisibility(status: false)
             self.presenter?.registerFeedBack(response: ValidationResponse(status: true, message: self.userMail!))
             self.presenter?.registerProgressVisibility(status: false)
             self.sendEmailVerification()
         }
         
     }
 }
 */

