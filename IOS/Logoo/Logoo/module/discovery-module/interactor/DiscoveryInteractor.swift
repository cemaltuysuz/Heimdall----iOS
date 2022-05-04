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
    
    var lastSnapshot:DocumentSnapshot?
    
    var presenter: InteractorToPresenterDiscorveryProtocol?
    var dbRef = Firestore.firestore()
    
    func getDiscoveredUsers(_ limit:Int) {
        guard let currentUserId = FirebaseAuthService.shared.getUUID() else {return}
        getUsers(currentUserId,limit,usersCompletion: {users in
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
    
    private func getUsers(_ currentUserId:String,_ limit:Int,usersCompletion: @escaping ([User]) -> Void){
        
        let query = getQuery(limit,currentUserId)
        
        FireStoreService.shared.getCollection(query: query, onCompletion: { (users:[User?]?, snapShot, error) in
            
            if let error = error {
                print(error)
                if self.lastSnapshot != nil {
                    self.presenter?.onStateChange(state: .pagedDataError) // get paged data error
                }else {
                    // Starter data are null
                    // TODO: SHOW ERROR MESSAGE
                }
                return
            }
            
            var nonOptionalUsers = [User]()
            if let users = users {
                self.lastSnapshot = snapShot
                for user in users {
                    if let user = user{
                        nonOptionalUsers.append(user)
                    }
                }
                usersCompletion(nonOptionalUsers)
            }
        })
    }
    
    func searchUser(_ keyword: String) {
        lastSnapshot = nil
        
        let lessValue = keyword + "\u{f8ff}"
        let query = dbRef.collection(FireStoreCollection.USER_COLLECTION)
            .whereField("username", isGreaterThanOrEqualTo: keyword.lowercased())
            .whereField("username", isLessThanOrEqualTo: lessValue.lowercased())
            
        
        FireStoreService.shared.getCollection(query: query, onCompletion: {(users:[User?]?,_,error) in
            if let error = error {
                print(error)
                // show error
            }
            
            var nonOptionalUsers = [User]()
            if let users = users {
                for user in users {
                    if let user = user {
                        nonOptionalUsers.append(user)
                    }
                }
                self.presenter?.onStateChange(state: .searchedUsers(users: nonOptionalUsers))
            }
        })
    }
    
    func resetPagination() {
        lastSnapshot = nil
    }
    
    func getQuery(_ limit:Int,_ userId:String) -> Query{
        if let lastSnapshot = lastSnapshot {
            return dbRef.collection(FireStoreCollection.USER_COLLECTION)
                .order(by: "userLastSeen", descending: true)
                .whereField("userId", isNotEqualTo: userId)
                .limit(to: limit)
                .start(afterDocument: lastSnapshot)

        }
        return dbRef.collection(FireStoreCollection.USER_COLLECTION)
            .whereField("userId", isNotEqualTo: userId)
            .limit(to: limit)
    }
}

