//
//  ProfileSettingsInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.02.2022.
//

import Foundation

class ProfileSettingsInteractor : PresenterToInteractorProfileSettingsProtocol {
    var presenter: InteractorToPresenterProfileSettingsProtocol?
    
    func getUser() {
        
    }
    
    func getOptions() {
        var options = [ProfileOuterOption]()
        
        options.append(ProfileOuterOption(iconName: "lock.shield.fill", optionTitle: "Security".localized()))
        options.append(ProfileOuterOption(iconName: "eye.slash.fill", optionTitle: "Privacy".localized()))
        options.append(ProfileOuterOption(iconName: "bell.fill", optionTitle: "Notifications".localized()))
        options.append(ProfileOuterOption(iconName: "person.fill.badge.plus", optionTitle: "Invite Friends".localized()))
        options.append(ProfileOuterOption(iconName: "paintpalette.fill", optionTitle: "Preferences".localized()))
        options.append(ProfileOuterOption(iconName: "info.circle.fill", optionTitle: "About".localized()))
        options.append(ProfileOuterOption(iconName: "rectangle.portrait.and.arrow.right.fill", optionTitle: "Exit".localized()))
        presenter?.optionsToPresenter(options: options)
    }
}
