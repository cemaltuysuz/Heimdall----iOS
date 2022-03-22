//
//  LGImageView.swift
//  Logoo
//
//  Created by cemal tüysüz on 22.03.2022.
//

import Foundation
import UIKit

class LGImageView  : UIImageView {
    
    var reDesigned:Bool?
    
    override func awakeFromNib() {
        layer.cornerRadius = 10
    }
    
    override var image: UIImage? {
        didSet{
            if oldValue != nil {
                if reDesigned != nil, reDesigned == true {
                    self.reDesigned = nil
                }
            }
        }
    }
}
