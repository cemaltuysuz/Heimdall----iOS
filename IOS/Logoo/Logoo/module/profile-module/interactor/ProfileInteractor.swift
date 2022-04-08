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
    
    func loadPage() {
        if let uuid = FirebaseAuthService.shared.getUUID() {
            let ref = Firestore.firestore().collection(FireCollections.USER_COLLECTION).document(uuid)
            FireStoreService.shared.getDocument(ref: ref, onCompletion: {(user:User?) in
                guard let user = user else {
                    // TODO: SEND ERROR MESSAGE
                    return
                }
                print(user.userInterests)
                self.presenter?.onStateChange(state: .onUserLoad(user: user))
            })
            
            FireStoreService.shared.getCollection(ref: ref.collection(FireCollections.USER_POSTS), onCompletion: { ( posts:[UserPost?]?, error) in
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
