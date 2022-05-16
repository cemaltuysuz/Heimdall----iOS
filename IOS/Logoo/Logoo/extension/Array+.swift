//
//  Array+.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.05.2022.
//

import Foundation

extension Array where Element == String {
    
    func dualConnectionOut() -> String? {
        if count == 2 {
            let sortedArray = sorted()
            return sortedArray[0] + sortedArray[1]
        }
        return nil
    }
}
