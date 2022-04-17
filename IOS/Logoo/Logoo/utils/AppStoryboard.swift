//
//  AppStoryboard.swift
//  Logoo
//
//  Created by cemal tüysüz on 17.04.2022.
//

import Foundation
import UIKit

enum AppStoryboard : String {
    case Welcome = "Welcome"
    case Discovery = "Discovery"
    case Global = "Global"
    case Profile = "Profile"
    case Chat = "Chat"
    case Security = "Security"
    case Settings = "Settings"
    
    var instance : UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(_ viewControllerClassType: T.Type) -> T{
        let storyBoardID = (viewControllerClassType as UIViewController.Type).storyBoardID()
        return instance.instantiateViewController(withIdentifier: storyBoardID) as! T
    }
}
