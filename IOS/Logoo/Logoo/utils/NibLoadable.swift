//
//  NibLoadable.swift
//  Logoo
//
//  Created by cemal tüysüz on 7.04.2022.
//

import Foundation


protocol NibLoadable: AnyObject { }

extension NibLoadable {

    static func loadFromNib() -> Self {
        let bundle = Bundle(for: self)
        let nibName = String(describing: self)
        guard let result = bundle.loadNibNamed(
            nibName,
            owner: self,
            options: nil
        )?.first as? Self else {
            fatalError("Cannot load view from nib.")
        }
        return result
    }
}



