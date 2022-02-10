//
//  Util.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.01.2022.
//

import Foundation


func hobbyToHobbies(hobby:String) -> [String]{
    let hobbies = hobby.components(separatedBy: "&")
        return hobbies
}

func timeInSeconds() -> Int {
    return Int(Date().timeIntervalSince1970 * 1000)
}


