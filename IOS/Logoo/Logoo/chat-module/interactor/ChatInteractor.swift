//
//  ChatInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 25.01.2022.
//

import Foundation

class ChatInteractor : PresenterToInteractorChatProtocol {
    var presenter: InteractorToPresenterChatProtocol?

    
    func getAllRequirements() {
        getRequests()
        getChats()
    }
    
    private func getChats(){
        var chatList = [Any]()
        var p2pMembers = [User]()
        var roomMembers = [User]()
        
        let user1 = User(userId: "1", username: "Cemal Tuysuz", userMail: "asdfg@gmail.com", userPhotoUrl: "htttp:dsda", userGender: .Male, userBirthDay: "08-09-1999", userBio: "Lorem impsun Dolor sit amet.", userHobbies: "Guitar&Programming&Sing the song&Travel", userLastSeen: "6125345216123", userRegisterTime: "15234562143", isAnonymous: "false", isOnline: "true", isAllowTheGroupInvite: "true", isAllowTheInboxInvite: "true")
        
        let user2 = User(userId: "2", username: "Caner Tuysuz", userMail: "asdfg@gmail.com", userPhotoUrl: "htttp:dsda", userGender: .Male, userBirthDay: "08-09-1999", userBio: "Lorem impsun Dolor sit amet.", userHobbies: "Guitar&Programming&Sing the song&Travel", userLastSeen: "6125345216123", userRegisterTime: "15234562143", isAnonymous: "false", isOnline: "true", isAllowTheGroupInvite: "true", isAllowTheInboxInvite: "true")
        
        let user3 = User(userId: "3", username: "Celal Çifteci", userMail: "asdfg@gmail.com", userPhotoUrl: "htttp:dsda", userGender: .Male, userBirthDay: "08-09-1999", userBio: "Lorem impsun Dolor sit amet.", userHobbies: "Guitar&Programming&Sing the song&Travel", userLastSeen: "6125345216123", userRegisterTime: "15234562143", isAnonymous: "false", isOnline: "true", isAllowTheGroupInvite: "true", isAllowTheInboxInvite: "true")
        
        let user4 = User(userId: "1", username: "Semih Çamcı", userMail: "asdfg@gmail.com", userPhotoUrl: "htttp:dsda", userGender: .Male, userBirthDay: "08-09-1999", userBio: "Lorem impsun Dolor sit amet.", userHobbies: "Guitar&Programming&Sing the song&Travel", userLastSeen: "6125345216123", userRegisterTime: "15234562143", isAnonymous: "false", isOnline: "true", isAllowTheGroupInvite: "true", isAllowTheInboxInvite: "true")
        
        roomMembers.append(user1)
        roomMembers.append(user2)
        roomMembers.append(user3)
        roomMembers.append(user4)
        
        p2pMembers.append(user1)
        p2pMembers.append(user2)
        
        chatList.append(P2P(p2pId: "2", creationTime: "23.30", p2pMembers: p2pMembers))
        chatList.append(Room(roomId: "asdf", creatorId: "1", roomTitle: "Grup Katliam", roomDescription: "Grup aciklamasi", roomImageUrl: "resimUrl", roomMembers: roomMembers, creationTime: "12.10"))
        
        presenter?.chatsToPresenter(chats: chatList)
    }
    
    private func getRequests(){
        var requests = [ChatRequest]()
        let req1 = ChatRequest(chatRequestId: "1", requestSenderId: "a", requestReceiverId: "b", requestType: .ROOM_REQUEST, timestamp: "12.10")
        
        let req2 = ChatRequest(chatRequestId: "1", requestSenderId: "a", requestReceiverId: "b", requestType: .P2P_REQUEST, timestamp: "13.30")
        
        requests.append(req1)
        requests.append(req2)
        
        presenter?.requestsToPresenter(requests: requests)
    }
    
    
}
