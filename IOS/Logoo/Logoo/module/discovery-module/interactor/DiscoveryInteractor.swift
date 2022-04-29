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
    
    var previousUsersDateLimit = 5
    var pageLimit = 10
    
    var presenter: InteractorToPresenterDiscorveryProtocol?
    var dbRef = Firestore.firestore()
    
    func getDiscoveredUsers() {
        guard let currentUserId = FirebaseAuthService.shared.getUUID() else {return}
        getUsers(currentUserId,usersCompletion: {users in
            self.presenter?.onStateChange(state: .discoveredUsers(users: users))
        })
    }
    
    
    // MARK: - Get Current User From FireStore
    private func getCurrentUser(userCompletion : @escaping (User?) -> Void) {
        guard let uid = FirebaseAuthService.shared.getUUID() else{
            print("Eror : User UUID is not found.")
            userCompletion(nil)
            return
        }
        
        let currentUserDocumentRef = dbRef.collection(FireStoreCollection.USER_COLLECTION).document(uid)
        FireStoreService.shared.getDocument(ref: currentUserDocumentRef,
                                            onCompletion: {(user:User?) in
            if let user = user {
                userCompletion(user)
            }else {
                print("Error: User document is not found.")
                userCompletion(nil)
                return
            }
        })
    }
    // MARK: - Fetch list of users that the user has seen before
    private func getPreviousUsers(dateLimit:Int,userCompletion: @escaping ([PreviousUser]) -> Void) {
        let currentDate = Date()
        let previousDate = Calendar.current.date(byAdding: .day, value: -dateLimit, to: currentDate)
        let previousTimestamp = previousDate!.toMilliSeconds()
        // karşıdan gelen bilgi bu timestamp dan büyük olması lazım
        let previousUsersQuery = dbRef.collection(FireStoreCollection.USER_COLLECTION).whereField("timestamp", isGreaterThanOrEqualTo: previousTimestamp)
        
        FireStoreService.shared.getCollection(query: previousUsersQuery,
                                              onCompletion: {(users: [PreviousUser?]?,_,error) in
            guard let error = error else {
                var nonOptionalPreviousUsers = [PreviousUser]()
                
                if let users = users {
                    for user in users {
                        if let user = user {
                            nonOptionalPreviousUsers.append(user)
                        }
                    }
                    userCompletion(nonOptionalPreviousUsers)
                }else {
                    print("Error : The Previous Users list is nil.")
                    userCompletion([])
                }
                return
            }
            print("Error : When getting Previous Users \(error)")
            userCompletion([])

        })
    }
    
    private func getUsers(_ currentUserId:String,usersCompletion: @escaping ([User]) -> Void){
        let ref = Firestore.firestore().collection(FireStoreCollection.USER_COLLECTION)
        FireStoreService.shared.getCollection(ref: ref,
                                              onCompletion: {(users:[User?]?,error) in
            var nonOptionalUsers = [User]()
            
            if let users = users {
                for user in users {
                    if let user = user, let uid = user.userId, currentUserId != uid {
                        let ref = Firestore.firestore().collection(FireStoreCollection.USER_COLLECTION).document(uid).collection(FireStoreCollection.USER_INTERESTS)
                        FireStoreService.shared.getCollection(ref: ref,
                                                              onCompletion: {(interests:[Interest?]?,error) in
                            var nonOptionalInterestList = [Interest]()
                            if let interests = interests {
                                for interest in interests {
                                    if let interest = interest {
                                        nonOptionalInterestList.append(interest)
                                    }
                                }
                                user.userInterests = nonOptionalInterestList
                                if user.userId == users.last??.userId {
                                    usersCompletion(nonOptionalUsers)
                                }
                            }
                        })
                        nonOptionalUsers.append(user)
                    }
                }
            }
            
        })
    }
}
