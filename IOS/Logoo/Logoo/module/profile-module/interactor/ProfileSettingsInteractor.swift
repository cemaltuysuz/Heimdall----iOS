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
    
    /**
     The user will be redirected to the login page in any case. But the result needs to be logged.
     */
    func exitUser() {
        do{
            try Auth.auth().signOut()
        }catch{
            print("Log out is failure. MSG: \(error.localizedDescription)")
        }
        self.presenter?.exitUserFeedback()
    }
    
    func getOptions() {
        var options = [MenuItem<ProfileSettingType>]()
        
        options.append(MenuItem(
            iconName: "person.fill.badge.plus",
            itemTitle: "Invite Friends".localized(),
            type: .INVITE_FRIENDS,
            isEnabled: false,
            warningMessage: nil))
        
        options.append(MenuItem(
            iconName: "lock.shield.fill",
            itemTitle: "Security".localized(),
            type: .SECURITY,
            isEnabled: true,
            warningMessage: nil))
        
        options.append(MenuItem(
            iconName: "paintpalette.fill",
            itemTitle: "Preferences".localized(),
            type: .PREFERENCES,
            isEnabled: true,
            warningMessage: nil))
        
        options.append(MenuItem(
            iconName: "gamecontroller.fill",
            itemTitle: "Interests".localized(),
            type: .INTERESTS,
            isEnabled: true,
            warningMessage: nil))
        
        options.append(MenuItem(
            iconName: "bell.fill",
            itemTitle: "Notifications".localized(),
            type: .NOTIFICATIONS,
            isEnabled: true,
            warningMessage: nil))
        
        options.append(MenuItem(
            iconName: "eye.slash.fill",
            itemTitle: "Privacy".localized(),
            type: .PRIVACY,
            isEnabled: true,
            warningMessage: nil))
        
        options.append(MenuItem(
            iconName: "info.circle.fill",
            itemTitle: "About".localized(),
            type: .ABOUT,
            isEnabled: true,
            warningMessage: nil))
        
        options.append(MenuItem(
            iconName: "rectangle.portrait.and.arrow.right.fill",
            itemTitle: "LogOut".localized(),
            type: .LOGOUT,
            isEnabled: true,
            warningMessage: nil))
        
        presenter?.optionsToPresenter(options: options)
    }
}
