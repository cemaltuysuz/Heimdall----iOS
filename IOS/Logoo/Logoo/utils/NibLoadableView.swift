//
//  LGView.swift
//  Logoo
//
//  Created by cemal tüysüz on 7.04.2022.
//

import Foundation
import UIKit


class NibLoadableView : UIView, NibLoadable {
    override func awakeAfter(using _: NSCoder) -> Any? {
        createdCustomViewFromNib()
    }
}
