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
        // get current user
        getCurrentUser(userCompletion: {currentUser in
            if let currentUser = currentUser {
                // current user interests
                var currentUserInterests = [String]()
                if let cInterests = currentUser.userInterests, !cInterests.isEmpty {
                    currentUserInterests += cInterests.toListByCharacter(GeneralConstant.INTEREST_SEPERATOR)
                }
                // get previous users
                self.getPreviousUsers(dateLimit: self.previousUsersDateLimit,
                                 userCompletion: {previousUsers in
                    
                })
            }else {
                // TODO: SHOW ERROR PAGE
            }
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
                                              onCompletion: {(users: [PreviousUser?]?,error) in
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
}
