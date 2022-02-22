//
//  PageAlert.swift
//  Logoo
//
//  Created by cemal tüysüz on 17.02.2022.
//

import Foundation
import UIKit

class PageAlert {
    var isThereATargetButton:Bool!
    var segueIdentifier:String?
    var title:String?
    var description:String?
    
    init(isThereATargetButton:Bool, segueIdentifier:String?, title: String? = nil, description: String? = nil) {
        self.isThereATargetButton = isThereATargetButton
        self.segueIdentifier = segueIdentifier
        self.title = title
        self.description = description
    }
}
