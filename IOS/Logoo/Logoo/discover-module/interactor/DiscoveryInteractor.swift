//
//  DiscoveryInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 23.01.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class DiscoveryInteractor : PresenterToInteractorDiscoveryProtocol {
    var presenter: InteractorToPresenterDiscorveryProtocol?
    var dbRef = Firestore.firestore()
    
    func getDiscoveredUsers() {
       var userList = [User]()
        
        dbRef.collection("users").getDocuments{(snapshot, error) in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
            }else {
                guard let snap = snapshot else {
                    return}
                                
                for document in snap.documents {
                    //document.
                    let data = document.data()
                    let user = User(
                        userId:   data["userId"]   as? String ?? "",
                        username: data["username"] as? String ?? "",
                        userMail: data["userMail"] as? String ?? "",
                        userPhotoUrl: data["userPhotoUrl"] as? String ?? "",
                        userGender: GenderType(rawValue: data["userGender"] as? String ?? "Other") ?? GenderType.Other,
                        userBirthDay: data["UserBirthDay"] as? String ?? "",
                        userBio: data["userBio"] as? String ?? "",
                        userInterests: data["userHobbies"] as? String ?? "",
                        userLastSeen: data["userLastSeen"] as? String ?? "",
                        userRegisterTime: data["userRegisterTime"] as? String ?? "",
                        isAnonymous: data["isAnonymous"] as! Bool,
                        isOnline: data["isOnline"] as! Bool,
                        isAllowTheGroupInvite: data["isAllowTheGroupInvite"] as! Bool,
                        isAllowTheInboxInvite: data["isAllowTheInboxInvite"] as! Bool
                    )
                    userList.append(user)
                }
            }
        }
    }
}
