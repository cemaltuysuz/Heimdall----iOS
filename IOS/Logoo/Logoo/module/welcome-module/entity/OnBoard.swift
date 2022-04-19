//
//  OnBoard.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import Foundation
import UIKit

class OnBoard {
    var image:UIImage!
    var title:String!
    var description:String?!
    
    init(){}
    
    init(image:UIImage,title:String,description:String){
        self.image = image
        self.title = title
        self.description = description
    }
}
