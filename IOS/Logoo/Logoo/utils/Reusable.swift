//
//  Reusable.swift
//  Logoo
//
//  Created by cemal tüysüz on 7.04.2022.
//

import Foundation

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
