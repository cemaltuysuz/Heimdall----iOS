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
        case SECURITY_VISUAL_VIBILITY = "SECURITY_VISUAL_VISIBILITY"
    }
}

enum LogEventType :String {
    case USER_SIGN_IN = "USER_SIGN_IN"
    case USER_SIGN_OUT = "USER_SIGN_OUT"
    case USER_PASSWORD_CHANGE = "USER_PASSWORD_CHANGE"
    case USER_MAIL_CHANGE = "USER_CHANGE_MAIL"
}

// Firebase Constants
class FireStoreCollection {
    static let USER_COLLECTION = "users"
    static let USER_POSTS = "posts" // inside user document
    static let INBOX_COLLECTION = "inboxes"
    static let DIRECT_COLLECTION = "directs"
    static let GROUP_COLLECTION = "groups"
    static let INTEREST_COLLECTION = "interests"
    static let LOG_COLLECTION = "logs"
    static let MESSAGE_COLLECTION = "messages"
    static let LOCATION_LOCATION = "locations"
}

class FireStoragePath {
    static let USER_PHOTO = "profiles"
    static let USER_POST = "posts"
}

class GeneralConstant {
    static let INTEREST_SEPERATOR = "&"
    static let USER_POST_HORIZONTAL_RATIO:Double = 4.0
    static let USER_POST_VERTICAL_RATIO:Double = 5.0
}


