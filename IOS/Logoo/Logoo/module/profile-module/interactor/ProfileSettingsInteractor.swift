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
        var options = [LineMenuItem]()
        
        options.append(LineMenuItem(
            iconName: "person.fill.badge.plus",
            itemTitle: "Invite Friends".localized(),
            rawValue: ProfileMenuItemType.INVITE_FRIENDS.rawValue,
            isEnabled: false,
            warningMessage: nil))
        
        options.append(LineMenuItem(
            iconName: "lock.shield.fill",
            itemTitle: "Security".localized(),
            rawValue: ProfileMenuItemType.SECURITY.rawValue,
            isEnabled: true,
            warningMessage: nil))
        
        options.append(LineMenuItem(
            iconName: "paintpalette.fill",
            itemTitle: "Preferences".localized(),
            rawValue: ProfileMenuItemType.PREFERENCES.rawValue,
            isEnabled: true,
            warningMessage: nil))
        
        options.append(LineMenuItem(
            iconName: "gamecontroller.fill",
            itemTitle: "Interests".localized(),
            rawValue: ProfileMenuItemType.INTERESTS.rawValue,
            isEnabled: true,
            warningMessage: nil))
        
        options.append(LineMenuItem(
            iconName: "bell.fill",
            itemTitle: "Notifications".localized(),
            rawValue: ProfileMenuItemType.NOTIFICATIONS.rawValue,
            isEnabled: true,
            warningMessage: nil))
        
        options.append(LineMenuItem(
            iconName: "eye.slash.fill",
            itemTitle: "Privacy".localized(),
            rawValue: ProfileMenuItemType.PRIVACY.rawValue,
            isEnabled: true,
            warningMessage: nil))
        
        options.append(LineMenuItem(
            iconName: "info.circle.fill",
            itemTitle: "About".localized(),
            rawValue: ProfileMenuItemType.ABOUT.rawValue,
            isEnabled: true,
            warningMessage: nil))
        
        options.append(LineMenuItem(
            iconName: "rectangle.portrait.and.arrow.right.fill",
            itemTitle: "LogOut".localized(),
            rawValue: ProfileMenuItemType.LOGOUT.rawValue,
            isEnabled: true,
            warningMessage: nil))
        
        presenter?.optionsToPresenter(options: options)
    }
}
