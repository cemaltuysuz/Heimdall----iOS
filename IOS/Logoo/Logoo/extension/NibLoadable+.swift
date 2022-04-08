//
//  NibLoadable+.swift
//  Logoo
//
//  Created by cemal tüysüz on 7.04.2022.
//

import Foundation
import UIKit

extension NibLoadable where Self: UIView {
    
    /// Loads the view from nib to be replaced with the empty view in awakeAfter(using:)
    ///
    /// - Returns: Self instance loaded from nib
    func createdCustomViewFromNib() -> Self {
        if subviews.isEmpty {
            let view = type(of: self).loadFromNib()
            
            view.frame = frame
            view.autoresizingMask = autoresizingMask
            view.translatesAutoresizingMaskIntoConstraints =
            translatesAutoresizingMaskIntoConstraints
            
            let constraints = self.constraints
            for constraint in constraints {
                var selfItem: UIView?
                let firstItem = constraint.firstItem as? UIView
                if firstItem == self {
                    selfItem = view
                }
                
                let secondItem = constraint.secondItem as? UIView
                if secondItem == self {
                    selfItem = view
                }
                
                if let firstItem = firstItem, let secondItem = secondItem {
                    view.addConstraint(
                        NSLayoutConstraint(
                            item: firstItem,
                            attribute: constraint.firstAttribute,
                            relatedBy: constraint.relation,
                            toItem: secondItem,
                            attribute: constraint.secondAttribute,
                            multiplier: constraint.multiplier,
                            constant: constraint.constant)
                    )
                } else if let selfItem = selfItem {
                    let constraint = NSLayoutConstraint(
                        item: selfItem,
                        attribute: constraint.firstAttribute,
                        relatedBy: constraint.relation,
                        toItem: nil,
                        attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                        multiplier: constraint.multiplier,
                        constant: constraint.constant)
                    
                    view.addConstraint(constraint)
                }
                
                selfItem = nil
            }
            return view
        }
        return self
    }
}
