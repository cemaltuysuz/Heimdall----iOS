//
//  UIToolbar.swift
//  Logoo
//
//  Created by cemal tüysüz on 4.03.2022.
//

import Foundation
import UIKit


extension UIToolbar {

 func ToolbarWithPicker(mySelect : Selector) -> UIToolbar {

    let toolBar = UIToolbar()

    toolBar.barStyle = UIBarStyle.default
    toolBar.isTranslucent = true
    toolBar.tintColor = .black
    toolBar.sizeToFit()

    let doneButton = UIBarButtonItem(title: "Done".localized, style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

    toolBar.setItems([ spaceButton, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true

    return toolBar
  }
}
