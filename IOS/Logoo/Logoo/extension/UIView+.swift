//
//  UIView+.swift
//  Logoo
//
//  Created by cemal tüysüz on 14.04.2022.
//

import Foundation
import UIKit

extension UIView {
    func getConstraint(withIndentifier indentifier: String) -> NSLayoutConstraint? {
        return self.constraints.filter { $0.identifier == indentifier }.first
    }
    
    func forceUpdateConstraint(constant: CGFloat, attribute:NSLayoutConstraint.Attribute) {
        constraints.forEach {
            if $0.firstAttribute == attribute {
                self.removeConstraint($0)
            }
        }
        
        heightAnchor.constraint(equalToConstant: constant).isActive = true
        superview?.layoutIfNeeded()
    }
    
    func addDashedBorder(radius:CGFloat){
        let border = CAShapeLayer()
        border.strokeColor = UIColor.black.cgColor
        border.lineDashPattern = [2, 2]
        border.frame = self.bounds
        border.fillColor = nil
        border.path = UIBezierPath(rect: self.bounds).cgPath
        border.name = "dashedLayer"
        border.cornerRadius = radius
        self.layer.addSublayer(border)
    }
    
    func removeDashedBorder(){
        for layer in self.layer.sublayers ?? [] where layer.name == "dashedLayer" {
            layer.removeFromSuperlayer()
        }
    }
    
    func addInputAccessoryForTextFields(textFields: [UITextField], dismissable: Bool = true, previousNextable: Bool = false) {
        for (index, textField) in textFields.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            var items = [UIBarButtonItem]()
            if previousNextable {
                let previousButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: nil, action: nil)
                previousButton.width = 30
                if textField == textFields.first {
                    previousButton.isEnabled = false
                } else {
                    previousButton.target = textFields[index - 1]
                    previousButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                let nextButton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: nil, action: nil)
                nextButton.width = 30
                if textField == textFields.last {
                    nextButton.isEnabled = false
                } else {
                    nextButton.target = textFields[index + 1]
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }
                items.append(contentsOf: [previousButton, nextButton])
            }
            
            if dismissable {
                let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.endEditing))
                items.append(contentsOf: [spacer, doneButton])
            }
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
    }
    
    func setRadius(_ value:CGFloat){
        layer.masksToBounds = true
        layer.cornerRadius = value
    }
    
    func setborder(_ width:CGFloat,
                   _ color:UIColor){
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
}
