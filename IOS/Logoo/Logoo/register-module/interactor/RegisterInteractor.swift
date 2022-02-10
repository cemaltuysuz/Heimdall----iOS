//
//  RegisterInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 3.02.2022.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RegisterInteractor : PresenterToInteractorRegisterMail{
    
    var presenter: InteractorToPresenterRegisterMail?
    var databaseRef:DatabaseReference!
    var storageRef:StorageReference!
    
    init(){
        databaseRef = Database.database().reference()
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
                 - Indicatoru durdur
                 - return et
                 */
                if let err = error {
                    self.presenter?.registerFeedBack(response: ValidationResponse(status: false, message: "Bir sorun oluştu. \(err.localizedDescription)"))
                    self.presenter?.registerProgressVisibility(status: false)
                    return
                }
                /**
                  Kullanıcıyı database kısmına kayıt etmek için bir veritabanı referansı oluşturuyorum
                 */
                let userRef = self.databaseRef.child("users").child(user!.user.uid)
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
                    "userRegisterTime"  : "\(timeInSeconds)",
                    "isAnonymous"       : "false",
                    "isOnline"          : "false",
                    "isAllowTheGroupInvite" : "true",
                    "isAllowTheInboxInvite" : "true"
                    
                    
                        ] as [String:Any]
                /**
                 Kullanıcıyı veritabanına işliyorum ;
                 Bu kısımda eğer kullanıcı veritabanına başarılı bir şekilde işlenirse kullanıcının profil resmini storage alanına upload edeceğim.
                 Sonrasında aldığım ref değeri ile bunu kullanıcı profil resmi olarak kayıt edeceğim.
                 */
                userRef.setValue(userObject){(error, rgRef)  in
                    if let err = error {
                        self.presenter?.registerFeedBack(response: ValidationResponse(status: false, message: "Error writing user to database. \(err.localizedDescription)"))
                        self.presenter?.registerProgressVisibility(status: false)
                        return
                    }
                    
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
                            }
                            
                        }
                    }
                    
                }
                
            }
       // KAYIT İŞLEMİ BİTTİ
            }
    }

