//
//  String+.swift
//  Logoo
//
//  Created by cemal tüysüz on 8.04.2022.
//

import Foundation

extension String {
    
    func toListByCharacter(_ char:String) -> [Self]{
        return self.components(separatedBy: char)
    }
}
