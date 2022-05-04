//
//  ProfileInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 7.04.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ProfileInteractor : PresenterToInteractorProfileProtocol {
    
    var presenter: InteractorToPresenterProfileProtocol?
    
    func loadPage(_ uid: String?) {
        let uid = uid ?? FirebaseAuthService.shared.getUUID()
        
        if let uuid = uid{
            let ref = Firestore.firestore().collection(FireStoreCollection.USER_COLLECTION).document(uuid)
            FireStoreService.shared.getDocument(ref: ref, onCompletion: {(user:User?) in
                guard let user = user else {
                    // TODO: SEND ERROR MESSAGE
                    return
                }
                let interestsRef = Firestore.firestore().collection(FireStoreCollection.USER_COLLECTION).document(uuid).collection(FireStoreCollection.USER_INTERESTS)
                
                FireStoreService.shared.getCollection(ref: interestsRef,
                                                      onCompletion: {(interests:[Interest?]?,error) in
                    if let error = error {
                        print(error)
                        // ERROR
                    }
                    var nonOptionalList = [Interest]()
                    
                    if let interests = interests {
                        for interest in interests {
                            if let interest = interest {
                                nonOptionalList.append(interest)
                            }
                        }
                    }
                    user.userInterests = nonOptionalList
                    self.presenter?.onStateChange(state: .onUserLoad(user: user))
                })
            })
            
            FireStoreService.shared.getCollection(ref: ref.collection(FireStoreCollection.USER_POSTS), onCompletion: { ( posts:[UserPost?]?, error) in
                guard let posts = posts, error == nil else {
                    print(posts ?? "posts is nil")
                    return
                }
                var nonNilPosts = [UserPost]()
                for post in posts {
                    if let post = post {
                        nonNilPosts.append(post)
                    }
                }
                self.presenter?.onStateChange(state: .onPostsLoadSuccess(posts: nonNilPosts))
            })
            
        }else {
            // TODO: SEND ERROR MESSAGE
        }
    }
}
