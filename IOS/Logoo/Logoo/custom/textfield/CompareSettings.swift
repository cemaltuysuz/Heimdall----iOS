//
//  CompareSettings.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.04.2022.
//

import Foundation

struct CompareSettings {
    var key:String!
    var value:String!
    var isMustSame:Bool!
    
    init(key: String? = nil, value: String? = nil, isMustSame: Bool? = nil) {
       self.key = key
       self.value = value
       self.isMustSame = isMustSame
   }
}
