//
//  User.swift
//  Logoo
//
//  Created by cemal tüysüz on 23.01.2022.
//

import Foundation

class User {
    var userId:String?
    var username:String?
    var userMail:String?
    var userPhotoUrl:String?
    var userGender:GenderType?
    var userBirthDay:String?
    var userBio:String?
    var userInterests:String?
    var userLastSeen:String?
    var userRegisterTime:String?
    var isAnonymous:Bool?
    var isOnline:Bool?
    var isAllowTheGroupInvite:Bool?
    var isAllowTheInboxInvite:Bool?
    var inbox:[InboxType]?
    
    init(){}
    
    init(userId: String, username: String, userMail: String, userPhotoUrl: String, userGender: GenderType, userBirthDay: String, userBio: String, userInterests:String, userLastSeen: String, userRegisterTime: String, isAnonymous: Bool, isOnline: Bool, isAllowTheGroupInvite: Bool, isAllowTheInboxInvite: Bool) {
        self.userId = userId
        self.username = username
        self.userMail = userMail
        self.userPhotoUrl = userPhotoUrl
        self.userGender = userGender
        self.userBirthDay = userBirthDay
        self.userBio = userBio
        self.userInterests = userInterests
        self.userLastSeen = userLastSeen
        self.userRegisterTime = userRegisterTime
        self.isAnonymous = isAnonymous
        self.isOnline = isOnline
        self.isAllowTheGroupInvite = isAllowTheGroupInvite
        self.isAllowTheInboxInvite = isAllowTheInboxInvite
    }
    
    
}
