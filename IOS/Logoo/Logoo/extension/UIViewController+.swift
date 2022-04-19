//
//  UIViewController+.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.04.2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    static func storyBoardID()->String {return "\(self)"}
    
    static func instantiate(from:AppStoryboard) -> Self { return from.viewController(self)}
    

}
