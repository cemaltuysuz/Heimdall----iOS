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

class RegisterInteractor : PresenterToInteractorRegisterMail{
    
    var presenter: InteractorToPresenterRegisterMail?
    var ref:DatabaseReference!
    
    init(){
        ref = Database.database().reference()
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
                
                if let err = error {
                    print(err)
                    return
                }
                let userRef = self.ref.child("users").child(user!.user.uid)
                let userObject = [
                    "userId"            : user!.user.uid,
                    "username"          : self.userName!,
                    "userMail"          : self.userMail!,
                    "userPhotoUrl"      : "PHOTO URL",
                    "userGender"        : self.userGender!.rawValue,
                    "userBirthDay"      : self.userBirthDay!,
                    "userBio"           : "",
                    "userHobbies"       : "",
                    "userLastLogin"     : "LAST LOGIN",
                    "userRegisterTime"  : "REG TIME",
                    "isAnonymous"       : "false",
                    "isOnline"          : "false",
                    "isAllowTheGroupInvite" : "true",
                    "isAllowTheInboxInvite" : "true"
                    
                    
                        ] as [String:Any]
                userRef.setValue(userObject){(error, ref)  in
                    
                }
                
            }
       // KAYIT İŞLEMİ BİTTİ
                self.presenter?.registerProgressVisibility(status: false)
            }
    }

