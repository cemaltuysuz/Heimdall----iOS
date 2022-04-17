//
//  RegisterProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 22.01.2022.
//

import Foundation

protocol Registerable {
    func validate() -> ValidationResponse    
}
