//
//  Interest.swift
//  Logoo
//
//  Created by cemal tüysüz on 19.04.2022.
//

import Foundation

struct Interest: Codable {
    let interestKey, interestEN, interestTR: String

    enum CodingKeys: String, CodingKey {
        case interestKey = "InterestKey"
        case interestEN = "InterestEN"
        case interestTR = "InterestTR"
    }
    
    func getInterest() -> String {
        return Locale.current.languageCode == "tr" ? interestTR : interestEN
    }
}
