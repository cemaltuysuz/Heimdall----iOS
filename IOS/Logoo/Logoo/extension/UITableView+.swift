//
//  UITableView+.swift
//  Logoo
//
//  Created by cemal tüysüz on 8.04.2022.
//

import Foundation
import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_ type: T.Type) {
        register(UINib(nibName: type.reuseIdentifier,
                       bundle: nil),
                 forCellReuseIdentifier: T.reuseIdentifier)
        
    }
    
    func dequeue<T: UITableViewCell>(
        _ indexPath: IndexPath,
        type: T.Type = T.self
    ) -> T {
        if let cell = dequeueReusableCell(withIdentifier: type.reuseIdentifier,
                                          for: indexPath) as? T {
            return cell
        }
        return T()
    }
}
