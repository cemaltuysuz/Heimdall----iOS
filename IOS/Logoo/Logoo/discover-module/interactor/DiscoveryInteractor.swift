//
//  DiscoveryInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 23.01.2022.
//

import Foundation

class DiscoveryInteractor : PresenterToInteractorDiscoveryProtocol {
    var presenter: InteractorToPresenterDiscorveryProtocol?
    
    func getDiscoveredUsers() {
        var userList = [User]()
        
        let user1 = User(userId: "1", username: "Cemal Tuysuz", userMail: "asdfg@gmail.com", userPhotoUrl: "htttp:dsda", userGender: "male", userBirthDay: "08-09-1999", userBio: "Lorem impsun Dolor sit amet.", userHobbies: "Guitar&Programming&Sing the song&Travel", userLastLogin: "6125345216123", userRegisterTime: "15234562143", isAnonymous: "false", isOnline: "true", isAllowTheGroupInvite: "true", isAllowTheInboxInvite: "true")
        
        let user2 = User(userId: "2", username: "Caner Tuysuz", userMail: "asdfg@gmail.com", userPhotoUrl: "htttp:dsda", userGender: "male", userBirthDay: "08-09-1999", userBio: "Lorem impsun Dolor sit amet.", userHobbies: "Guitar&Programming&Sing the song&Travel", userLastLogin: "6125345216123", userRegisterTime: "15234562143", isAnonymous: "false", isOnline: "true", isAllowTheGroupInvite: "true", isAllowTheInboxInvite: "true")
        
        let user3 = User(userId: "3", username: "Celal Çifteci", userMail: "asdfg@gmail.com", userPhotoUrl: "htttp:dsda", userGender: "male", userBirthDay: "08-09-1999", userBio: "Lorem impsun Dolor sit amet.", userHobbies: "Guitar&Programming&Sing the song&Travel", userLastLogin: "6125345216123", userRegisterTime: "15234562143", isAnonymous: "false", isOnline: "true", isAllowTheGroupInvite: "true", isAllowTheInboxInvite: "true")
        
        let user4 = User(userId: "1", username: "Semih Çamcı", userMail: "asdfg@gmail.com", userPhotoUrl: "htttp:dsda", userGender: "male", userBirthDay: "08-09-1999", userBio: "Lorem impsun Dolor sit amet.", userHobbies: "Guitar&Programming&Sing the song&Travel", userLastLogin: "6125345216123", userRegisterTime: "15234562143", isAnonymous: "false", isOnline: "true", isAllowTheGroupInvite: "true", isAllowTheInboxInvite: "true")
        
        userList.append(user1)
        userList.append(user2)
        userList.append(user3)
        userList.append(user4)
        
        presenter?.discoveredUsersToPresenter(users: userList)
    }
}
