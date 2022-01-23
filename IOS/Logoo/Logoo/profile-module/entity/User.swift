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
    var userGender:String?
    var userBirthDay:String?
    var userBio:String?
    var userLastLogin:String?
    var userRegisterTime:String?
    var isAnonymous:String?
    var isOnline:String?
    var isAllowTheGroupInvite:String?
    var isAllowTheInboxInvite:String?
    
    init(){}
    
    init(userId: String, username: String, userMail: String, userPhotoUrl: String, userGender: String, userBirthDay: String, userBio: String, userLastLogin: String, userRegisterTime: String, isAnonymous: String, isOnline: String, isAllowTheGroupInvite: String, isAllowTheInboxInvite: String) {
        self.userId = userId
        self.username = username
        self.userMail = userMail
        self.userPhotoUrl = userPhotoUrl
        self.userGender = userGender
        self.userBirthDay = userBirthDay
        self.userBio = userBio
        self.userLastLogin = userLastLogin
        self.userRegisterTime = userRegisterTime
        self.isAnonymous = isAnonymous
        self.isOnline = isOnline
        self.isAllowTheGroupInvite = isAllowTheGroupInvite
        self.isAllowTheInboxInvite = isAllowTheInboxInvite
    }
    
    
}
