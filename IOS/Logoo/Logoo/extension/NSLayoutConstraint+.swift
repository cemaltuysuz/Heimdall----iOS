//
//  NSLayoutConstraint+.swift
//  Logoo
//
//  Created by cemal tüysüz on 14.04.2022.
//

import Foundation
import UIKit


extension NSLayoutConstraint {
    func activate(withIdentifier identifier: String) {
        self.identifier = identifier
        self.isActive = true
    }
}
