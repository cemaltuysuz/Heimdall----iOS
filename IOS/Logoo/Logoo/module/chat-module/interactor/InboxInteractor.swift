//
//  ChatInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 25.01.2022.
//

import Foundation
import FirebaseFirestore

class InboxInteractor : PresenterToInteractorInboxProtocol{
    var presenter: InteractorToPresenterInboxProtocol?
    let dbRef = Firestore.firestore()
    
    
    func startConnection() {
        connectRequests()
        connectInbox()
    }
    
    func connectRequests() {
        guard let uid = FirebaseAuthService.shared.getUUID() else {return}
        
        let ref = dbRef.collection(FireStoreCollection.USER_COLLECTION)
            .document(uid)
            .collection(FireStoreCollection.USER_REQUESTS)
            .whereField("requestResponse", isEqualTo: RequestResponseType.WAITING.rawValue)
        
        ref.addSnapshotListener({ querySnapShot,error in
            guard let snapShot = querySnapShot else {
                print(error!)
                return
            }
            var requests = [Request]()
            
            for document in snapShot.documents {
                let document = document as QueryDocumentSnapshot?
                let result = Result {
                    try document.flatMap {
                        try $0.data(as: Request.self)
                    }
                }
                switch result {
                case .success(let document) :
                    if let document = document {
                        requests.append(document)
                        
                    }
                    break
                case .failure(let error):
                    print("Error decoding Document \(error)")
                    break
                }
            }
            let sortedList = requests.sorted(by: {$0.timestamp ?? 0 > $1.timestamp ?? 0})
            self.presenter?.onStateChange(state: .onRequestsChange(requests: sortedList))
            return
        })
    }
    
    func connectInbox() {
        guard let uid = FirebaseAuthService.shared.getUUID() else {return}

        let ref = dbRef.collection(FireStoreCollection.DUAL_CONNECTION_COLLECTION)
        
        ref.addSnapshotListener({ querySnapShot,error in
            guard let snapShot = querySnapShot else {
                print(error!)
                return
            }
            var tempDuals = [DualConnection]()
            var visibleInboxes = [VisibleInbox]()
            
            for document in snapShot.documents {
                let document = document as QueryDocumentSnapshot?
                let result = Result {
                    try document.flatMap {
                        try $0.data(as: DualConnection.self)
                    }
                }
                switch result {
                case .success(let document) :
                    if let document = document {
                        tempDuals.append(document)
                        
                    }
                    break
                case .failure(let error):
                    print("Error decoding Document \(error)")
                    break
                }
            }
            
            var duals = [DualConnection]()
            
            for dual in tempDuals {
                if dual.connectionKey.contains(uid) {
                    duals.append(dual)
                }
            }
            
            for dual in duals {
                
                let receiverId = dual.connectionKey.getOtherUserIDFromConnectionKey(uid)
                let ref = self.dbRef.collection(FireStoreCollection.USER_COLLECTION)
                    .document(receiverId)
                
                FireStoreService.shared.getDocument(ref: ref,
                                                    onCompletion: {(user:User?) in
                    
                    if let user = user {
                        visibleInboxes.append(VisibleInbox(inboxPhotoURL: user.userPhotoUrl,
                                                           inboxTitle: user.username,
                                                           inboxLastMessage: dual.lastMessage,
                                                           inboxLastUpdateTime: dual.lastMessageTimestamp))
                    }
                    
                    if duals.last?.connectionKey == dual.connectionKey {
                        self.presenter?.onStateChange(state: .onInboxesChange(inboxes: visibleInboxes.sorted(by: {$0.inboxLastUpdateTime ?? 0 > $1.inboxLastUpdateTime ?? 0})))
                    }
                    
                })
            }
            
        })
        
    }
    
    func confirmRequest(_ request: Request) {
        
    }
}
