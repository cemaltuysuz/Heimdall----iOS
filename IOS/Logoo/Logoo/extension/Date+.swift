//
//  Date+.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.03.2022.
//

import Foundation

extension Date {
    func toStringWithPattern(pattern:String) -> String{
        let dateformat = DateFormatter()
        dateformat.dateFormat = pattern
        return dateformat.string(from: self)
    }
    
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
}
