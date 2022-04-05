//
//  Routable.swift
//  Logoo
//
//  Created by cemal tüysüz on 28.03.2022.
//

import Foundation
import UIKit

protocol Routable {
    associatedtype T : UIViewController
    
    func createModule()
}
