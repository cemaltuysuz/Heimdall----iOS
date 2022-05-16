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
            var requests = [RequestUser]()
            
            for document in snapShot.documents {
                let document = document as QueryDocumentSnapshot?
                let result = Result {
                    try document.flatMap {
                        try $0.data(as: Request.self)
                    }
                }
                switch result {
                case .success(let document) :
                    print("it is success")
                    if let document = document {
                        print("but not let")
                        requests.append(RequestUser(userUid: document.senderId, timestamp: document.timestamp))
                        
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
    
    func connectInbox(){
        guard let uid = FirebaseAuthService.shared.getUUID() else {return}
        
        let ref = dbRef.collection(FireStoreCollection.USER_COLLECTION)
            .document(uid)
            .collection(FireStoreCollection.USER_INBOX)
        
        ref.addSnapshotListener({ querySnapShot,error in
            guard let snapShot = querySnapShot else {
                return
            }
            var inboxes = [UserInbox]()
            for document in snapShot.documents {
                let document = document as QueryDocumentSnapshot?
                let result = Result {
                    try document.flatMap {
                        try $0.data(as: UserInbox.self)
                    }
                }
                switch result {
                case .success(let document) :
                    if let document = document {
                        inboxes.append(document)
                    }
                    break
                    
                case .failure(let error):
                    print("Error decoding Document \(error)")
                    break
                }
            }
            
            for inbox in inboxes {
                //let ref = self.dbRef.collection(<#T##collectionPath: String##String#>)
            }
            return
        })

    }
}
