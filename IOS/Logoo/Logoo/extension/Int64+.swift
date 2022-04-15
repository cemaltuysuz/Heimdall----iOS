//
//  INT64+.swift
//  Logoo
//
//  Created by cemal tüysüz on 12.04.2022.
//

import Foundation

extension Int64 {
    func milliSecondToDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self / 1000))
    }
}
