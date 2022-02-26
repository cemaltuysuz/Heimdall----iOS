//
//  Constants.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import Foundation

// For Util Constants
enum Constants {
    enum UserDefault : String {
        case ONBOARD_VISIBILITY = "ONBOARD_VISIBILITY"
        case MAIL_CONFIRMATION_TIME = "MAIL_CONFIRMATION_TIME"
        case MAIL_CONFIRMATION_SECOND = "MAIL_CONFIRMATIN_SECOND"
    }
}

// Firebase Constants
class FireCollections {
    static let USER_COLLECTION = "users"
    static let INBOX_COLLECTION = "inboxes"
    static let DIRECT_COLLECTION = "directs"
    static let GROUP_COLLECTION = "groups"
    static let INTEREST_COLLECTION = "interests"
    static let LOGINS_COLLECTION = "login-log"
    static let MESSAGE_COLLECTION = "messages"
    static let LOCATION_LOCATION = "locations"
}
