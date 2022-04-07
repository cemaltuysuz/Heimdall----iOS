//
//  UICollectionView+.swift
//  Logoo
//
//  Created by cemal tüysüz on 7.04.2022.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ type: T.Type) {
        register(UINib(nibName: type.reuseIdentifier,
                       bundle: nil),
                 forCellWithReuseIdentifier: T.reuseIdentifier)
        
    }
    
    func dequeue<T: UICollectionViewCell>(
        _ indexPath: IndexPath,
        type: T.Type = T.self
    ) -> T {
        if let cell = dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier,
                                          for: indexPath) as? T {
            return cell
        }
        return T()
    }
}
