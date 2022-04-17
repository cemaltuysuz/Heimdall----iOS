//
//  CustomTabBarController.swift
//  Logoo
//
//  Created by cemal tüysüz on 17.04.2022.
//

import Foundation
import UIKit

class CustomTabBarController : UITabBarController {
    
    
    override func viewDidLoad() {
        setupVC()
        configureUI()
    }
    
    func setupVC(){
        let discoveryVC = DiscoverVC.instantiate(from: .Discovery)
        discoveryVC.tabBarItem.image = UIImage(systemName: "person.3")
        discoveryVC.tabBarItem.selectedImage = UIImage(systemName: "person.3.fill")
        discoveryVC.title = "Discovery".localized()
        
        let discoveryNavigationController = UINavigationController(rootViewController: discoveryVC)
        discoveryNavigationController.navigationBar.prefersLargeTitles = true
        
        let globalVC = GlobalVC.instantiate(from: .Global)
        globalVC.tabBarItem.title = "Global".localized()
        globalVC.tabBarItem.image = UIImage(systemName: "globe.americas")
        globalVC.tabBarItem.selectedImage = UIImage(systemName: "globe.americas.fill")
        
        let globalNavigationController = UINavigationController(rootViewController: globalVC)
        
        let chatVC = ChatVC.instantiate(from: .Chat)
        chatVC.tabBarItem.title = "Chat".localized()
        chatVC.tabBarItem.image = UIImage(systemName: "bubble.left.and.bubble.right")
        chatVC.tabBarItem.selectedImage = UIImage(systemName: "bubble.left.and.bubble.right.fill")
        
        let chatNavigationController = UINavigationController(rootViewController: chatVC)
        chatNavigationController.navigationBar.prefersLargeTitles = true
        
        let profileVC = ProfileVC.instantiate(from: .Profile)
        profileVC.tabBarItem.title = "Profile".localized()
        profileVC.tabBarItem.image = UIImage(systemName: "person")
        profileVC.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        let profileNavigationController = UINavigationController(rootViewController: profileVC)
        profileNavigationController.navigationBar.prefersLargeTitles = true
        
        viewControllers = [discoveryNavigationController, globalNavigationController, chatNavigationController, profileNavigationController]
    }
    
    func configureUI(){
        tabBar.tintColor = Color.black700 ?? UIColor.black
    }
}
