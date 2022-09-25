//
//  ChatInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 28.05.2022.
//

import Foundation
import FirebaseFirestore
import MessageKit

class ChatInteractor : PresenterToInteractorChatProtocol {
    
    var presenter: InteractorToPresenterChatProtocol?
    var dbRef = Firestore.firestore()
    var connectionUid:String?
    
    func connectMessages(_ connectionUid: String) {
        
        guard let uid = FirebaseAuthService.shared.getUUID() else {return}
        
        self.connectionUid = connectionUid
        
        // get other user informations
        let otherUserUid = connectionUid.getOtherUserIDFromConnectionKey(uid)
        
        let otherUserRef = dbRef.collection(FireStoreCollection.USER_COLLECTION)
            .document(otherUserUid)
        
        FireStoreService.shared.getDocument(ref: otherUserRef,
                                            onCompletion: {(user:User?) in
            
            if let otherUser = user {
                // Success : Get Other User
                
                // get current user informations
                
                let currentUserRef = self.dbRef.collection(FireStoreCollection.USER_COLLECTION)
                    .document(uid)
                
                FireStoreService.shared.getDocument(ref: currentUserRef,
                                                    onCompletion: {(user:User?) in
                    
                    if let currentUser = user {
                        // Success : Get Current User Informations
                        let currentMessager = CurrentMessager(senderId: uid,
                                                              displayName: currentUser.username ?? "You",
                                                              photoUrl: currentUser.userPhotoUrl ?? "")
                        
                        let otherMessager = OtherMessager(senderId: otherUserUid,
                                                          displayName: otherUser.username ?? "Your Connection",
                                                          photoUrl: otherUser.userPhotoUrl ?? "")
                        
                        // Connect Messages
                        let messagesQuery = self.dbRef.collection(FireStoreCollection.DUAL_CONNECTION_COLLECTION)
                            .document(connectionUid)
                            .collection(FireStoreCollection.MESSAGE_COLLECTION)
                        
                        messagesQuery.addSnapshotListener({ querySnapShot,error in
                            guard let snapShot = querySnapShot else {
                                print(error!)
                                return
                            }
                            var messages = [MessageRemote]()
                            
                            for document in snapShot.documents {
                                let document = document as QueryDocumentSnapshot?
                                let result = Result {
                                    try document.flatMap {
                                        try $0.data(as: MessageRemote.self)
                                    }
                                }
                                switch result {
                                case .success(let document) :
                                    if let document = document {
                                        messages.append(document)
                                        
                                    }
                                    break
                                case .failure(let error):
                                    print("Error decoding Document \(error)")
                                    break
                                }
                            }
                            
                            var visibleMessages = [MessageLocal]()
                            for message in messages {
                                var senderType:SenderType?

                                if message.senderID == uid {
                                    senderType = currentMessager
                                }else {
                                    senderType = otherMessager
                                }
                                
                                visibleMessages.append(MessageLocal(sender: senderType!,
                                                                    messageId: message.messageID,
                                                                    sentDate: message.timestamp.milliSecondToDate(),
                                                                    kind: MessageKind.text(message.messageText)))
                            }
                            let currentMessager = CurrentMessager(senderId: uid,
                                                                  displayName: currentUser.username ?? "You",
                                                                  photoUrl: currentUser.userPhotoUrl ?? "")
                            self.presenter?.onStateChange(state: .onMessagesUpdated(messages: visibleMessages.sorted(by: {$0.sentDate < $1.sentDate}),sender: currentMessager))
                            return
                        })
                        
                    }else {
                        // Fail : Get Current User Informations
                    }
                })
            }else {
                // Fail : Get Other User
            }
        })
    }
    
    func sendMessage(_ text: String) {
        guard let uid = FirebaseAuthService.shared.getUUID() else {return}
        
        if let connectionUid = connectionUid {
            let messageID = UUID().uuidString
            
            let remoteMessage = MessageRemote(messageID: messageID,
                                              timestamp: timeInSeconds(),
                                              senderID: uid,
                                              messageText: text,
                                              contentURL: "")
            
            let messagePath = dbRef.collection(FireStoreCollection.DUAL_CONNECTION_COLLECTION)
                .document(connectionUid)
                .collection(FireStoreCollection.MESSAGE_COLLECTION)
                .document(messageID)
            
            FireStoreService.shared.pushDocument(remoteMessage,
                                                 ref: messagePath, onCompletion: { status in
                
                if let status = status , status{
                    self.presenter?.onStateChange(state: .onMessageSendSucces)
                }
                
            })
            
            let inboxInfoPath = dbRef.collection(FireStoreCollection.DUAL_CONNECTION_COLLECTION)
                .document(connectionUid)
            
            let dualConnection = DualConnection(connectionKey: connectionUid,
                                                timestamp: timeInSeconds(),
                                                lastMessage: text,
                                                lastMessageTimestamp: timeInSeconds())
            
            FireStoreService.shared.pushDocument(dualConnection,
                                                 ref: inboxInfoPath,
                                                 onCompletion: { status in
                
                if status == true {
                    // UPDATE IS SUCCEEDED
                }else {
                    // UPDATE IS FAIL 
                }
                
            })
        }
    }
    
}
