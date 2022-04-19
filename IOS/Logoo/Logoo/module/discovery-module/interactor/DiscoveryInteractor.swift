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
        
        getCurrentUser(userCompletion: {user in
            if let user = user {
                
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

}
