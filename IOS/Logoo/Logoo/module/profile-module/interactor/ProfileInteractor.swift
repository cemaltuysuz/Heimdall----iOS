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
        guard let currentUserUid = FirebaseAuthService.shared.getUUID() else {return}
        
        let uuid = uid ?? currentUserUid
        
        let ref = Firestore.firestore().collection(FireStoreCollection.USER_COLLECTION).document(uuid)
        FireStoreService.shared.getDocument(ref: ref, onCompletion: {(user:User?) in
            
            guard let user = user else {
                // TODO: SEND ERROR MESSAGE
                return
            }
            
            if uuid != currentUserUid {
                if !(user.isAllowTheInboxInvite ?? false) {
                    // check connection
                    if let connectionUid = [currentUserUid,uuid].dualConnectionOut() {
                        
                        let documentRef = Firestore.firestore()
                            .collection(FireStoreCollection.DUAL_CONNECTION_COLLECTION)
                            .document(connectionUid)
                        
                        FireStoreService.shared.getDocument(ref: documentRef, onCompletion: { (connetion:DualConnection?) in
                            
                            if let _ = connetion {
                                
                                self.presenter?.onStateChange(state: .onProfileVisibleState(type: .userVisible))
                                
                            }else {
                                
                                self.presenter?.onStateChange(state: .onProfileVisibleState(type: .inVisible))
                                
                            }
                            
                        })
                        
                    }else {
                        self.presenter?.onStateChange(state: .onProfileVisibleState(type: .inVisible))
                    }
                    
                }else {
                    
                    self.presenter?.onStateChange(state: .onProfileVisibleState(type: .visible))
                    
                }
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
    }
    
    func sendToRequest(_ uid:String?) {
        guard let currentUserUid = FirebaseAuthService.shared.getUUID() else {return}
        
        if let uid = uid {
            
            let uniqueId = UUID().uuidString
            let timestamp = timeInSeconds()
            let type = RequestType.DIRECT_REQUEST.rawValue
            let responseType = RequestResponseType.WAITING.rawValue
            
            let ref = Firestore.firestore()
                .collection(FireStoreCollection.USER_COLLECTION)
                .document(uid)
                .collection(FireStoreCollection.USER_REQUESTS)
                .document(uniqueId)
            
            let requestData = Request(requestId: uniqueId,
                                      senderId: currentUserUid,
                                      timestamp: timestamp,
                                      requestType: type,
                                      requestResponse: responseType)
            
            FireStoreService.shared.pushDocument(requestData, ref: ref, onCompletion: { (status:Bool?) in
                (status ?? false) ? self.presenter?.onStateChange(state: .onAlert(title: "Success".localized, message: "Your request has been sent successfully".localized)) : self.presenter?.onStateChange(state: .onAlert(title: "Error".localized, message: "Something went wrong.".localized))
            })
        }
    }
}
