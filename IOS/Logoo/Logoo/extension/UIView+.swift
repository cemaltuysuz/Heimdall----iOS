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
    
    func addDashedBorder(){
        let border = CAShapeLayer()
        border.strokeColor = UIColor.black.cgColor
        border.lineDashPattern = [2, 2]
        border.frame = self.bounds
        border.fillColor = nil
        border.path = UIBezierPath(rect: self.bounds).cgPath
        border.name = "dashedLayer"
        self.layer.addSublayer(border)
    }
    
    func removeDashedBorder(){
        for layer in self.layer.sublayers ?? [] where layer.name == "dashedLayer" {
            layer.removeFromSuperlayer()
        }
    }
}
