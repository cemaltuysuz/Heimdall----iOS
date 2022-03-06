//
//  ProfileSettingsInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.02.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class ProfileSettingsInteractor : PresenterToInteractorProfileSettingsProtocol {
    
    var presenter: InteractorToPresenterProfileSettingsProtocol?
    
    func getUser() {
        if let uuid = getCurrentUserUid() {
            let ref = Firestore.firestore().collection(FireCollections.USER_COLLECTION).document(uuid)
            FireStoreService.shared.getDocument(ref: ref, onCompletion: {(user:User?) in
                if let user = user {
                    self.presenter?.userToPresenter(user: user)
                }
            })
        }
    }
    /**
     The user will be redirected to the login page in any case. But the result needs to be logged.
     */
    func exitUser() {
        do{
            try Auth.auth().signOut()
        }catch{
            print("Log out is failure. status \(error.localizedDescription)")
        }
        self.presenter?.exitUserFeedback()
    }
    
    func getOptions() {
        var options = [ProfileOuterOption]()
        
        options.append(ProfileOuterOption(
            iconName: "person.fill.badge.plus",
            optionTitle: "Invite Friends".localized(),
            userSettingType: .INVITE_FRIENDS))
        
        options.append(ProfileOuterOption(
            iconName: "lock.shield.fill",
            optionTitle: "Security".localized(),
            userSettingType: .SECURITY))
        
        options.append(ProfileOuterOption(
            iconName: "paintpalette.fill",
            optionTitle: "Preferences".localized(),
            userSettingType: .PREFERENCES))
        
        options.append(ProfileOuterOption(
            iconName: "gamecontroller.fill",
            optionTitle: "Interests".localized(),
            userSettingType: .INTERESTS))
        
        options.append(ProfileOuterOption(
            iconName: "bell.fill",
            optionTitle: "Notifications".localized(),
            userSettingType: .NOTIFICATIONS))
        
        options.append(ProfileOuterOption(
            iconName: "eye.slash.fill",
            optionTitle: "Privacy".localized(),
            userSettingType: .PRIVACY))
        
        options.append(ProfileOuterOption(
            iconName: "info.circle.fill",
            optionTitle: "About".localized(),
            userSettingType: .ABOUT))
        
        options.append(ProfileOuterOption(
            iconName: "rectangle.portrait.and.arrow.right.fill",
            optionTitle: "LogOut".localized(),
            userSettingType: .LOGOUT))
        
        presenter?.optionsToPresenter(options: options)
    }
}
