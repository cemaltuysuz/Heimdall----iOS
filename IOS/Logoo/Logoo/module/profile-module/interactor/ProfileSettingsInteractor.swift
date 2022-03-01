//
//  ProfileSettingsInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.02.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ProfileSettingsInteractor : PresenterToInteractorProfileSettingsProtocol {
    var presenter: InteractorToPresenterProfileSettingsProtocol?
    
    func getUser() {
        if let uuid = getCurrentUserUid() {
            let ref = Firestore.firestore().collection(FireCollections.USER_COLLECTION).document(uuid)
            FireStoreService<User>().getDocument(ref: ref, onCompletion: {user in
                if let user = user {
                    self.presenter?.userToPresenter(user: user)
                }
            })
        }
    }
    
    func getOptions() {
        var options = [ProfileOuterOption]()
        
        options.append(ProfileOuterOption(iconName: "person.fill.badge.plus", optionTitle: "Invite Friends".localized()))
        options.append(ProfileOuterOption(iconName: "lock.shield.fill", optionTitle: "Security".localized()))
        options.append(ProfileOuterOption(iconName: "paintpalette.fill", optionTitle: "Preferences".localized()))
        options.append(ProfileOuterOption(iconName: "gamecontroller.fill", optionTitle: "Interests"))
        options.append(ProfileOuterOption(iconName: "bell.fill", optionTitle: "Notifications".localized()))
        options.append(ProfileOuterOption(iconName: "eye.slash.fill", optionTitle: "Privacy".localized()))
        options.append(ProfileOuterOption(iconName: "info.circle.fill", optionTitle: "About".localized()))
        options.append(ProfileOuterOption(iconName: "rectangle.portrait.and.arrow.right.fill", optionTitle: "Exit".localized()))
        presenter?.optionsToPresenter(options: options)
    }
}
