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
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            
            self.presenter?.discoveredUsersResponse(
                response: Resource<[User]>(
                    status: .ERROR,
                    data: nil,
                    message: nil // TODO
                )
            )
            return
        }
        
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
                    let userId = data["userId"]   as? String ?? ""
                    
                    if !userId.isEmpty && userId != currentUserId {
                        
                        let user = User(
                            userId: userId,
                            username: data["username"] as? String ?? "",
                            userMail: data["userMail"] as? String ?? "",
                            userPhotoUrl: data["userPhotoUrl"] as? String ?? "",
                            userGender: data["userGender"] as? String ?? "Other",
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
                self.presenter?.discoveredUsersResponse(
                    response: Resource<[User]>(
                        status: .SUCCESS,
                        data: userList,
                        message: nil
                    )
                )
            }
        }
    }
}
