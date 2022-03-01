//
//  UIImageViewEx.swift
//  Logoo
//
//  Created by cemal tüysüz on 1.03.2022.
//

import Foundation
import Kingfisher
import UIKit



extension UIImageView {
    
    func setImage(url:URL){
        self.kf.setImage(with: url)
    }
}


