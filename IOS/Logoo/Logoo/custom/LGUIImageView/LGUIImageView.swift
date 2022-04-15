//
//  LGUIImageView.swift
//  Logoo
//
//  Created by cemal tüysüz on 15.04.2022.
//

import Foundation
import UIKit

class LGUIImageView : UIView{
    @IBOutlet weak var imageView: UIImageView!
    
    
    func setImage(image:UIImage) {
        imageView.image = image
    }
    
    func setImage(imageUrl:String) {
        imageView.setImage(urlString: imageUrl)
    }

    func setImage(imageUrl:String, radius:CGFloat) {
        imageView.setImage(urlString: imageUrl, radius: radius)
    }
}
