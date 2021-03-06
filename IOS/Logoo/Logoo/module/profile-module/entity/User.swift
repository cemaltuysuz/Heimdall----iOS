//
//  User.swift
//  Logoo
//
//  Created by cemal tüysüz on 23.01.2022.
//

import Foundation

class User : Codable {
    var userId:String?
    var username:String?
    var userMail:String?
    var userPhotoUrl:String?
    var userGender:String?
    var userBirthDay:String?
    var userLiveCountry:String?
    var userManifesto:String?
    var userInterests:[Interest]?
    var userLastSeen:String?
    var userRegisterTime:String?
    var isAnonymous:Bool?
    var isOnline:Bool?
    var isAllowTheGroupInvite:Bool?
    var isAllowTheInboxInvite:Bool?
    
    init(){}
    
    init(userId: String, username: String, userMail: String?, userPhotoUrl: String, userGender: String, userBirthDay: String, userLiveCountry:String? = nil, userManifesto: String, userInterests:[Interest], userLastSeen: String, userRegisterTime: String, isAnonymous: Bool, isOnline: Bool, isAllowTheGroupInvite: Bool, isAllowTheInboxInvite: Bool) {
        self.userId = userId
        self.username = username
        self.userMail = userMail
        self.userPhotoUrl = userPhotoUrl
        self.userGender = userGender
        self.userBirthDay = userBirthDay
        self.userLiveCountry = userLiveCountry
        self.userManifesto = userManifesto
        self.userInterests = userInterests
        self.userLastSeen = userLastSeen
        self.userRegisterTime = userRegisterTime
        self.isAnonymous = isAnonymous
        self.isOnline = isOnline
        self.isAllowTheGroupInvite = isAllowTheGroupInvite
        self.isAllowTheInboxInvite = isAllowTheInboxInvite
    }
}
