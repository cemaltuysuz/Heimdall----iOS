//
//  RequestInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.05.2022.
//

import Foundation
import FirebaseFirestore


class RequestInteractor : PresenterToInteractorRequestProtocol {
    var presenter: InteractorToPresenterRequestProtocol?
    
    var dbRef = Firestore.firestore()
    
    func getTargetUserFromRequest(_ req: Request) {
        
        let ref = dbRef.collection(FireStoreCollection.USER_COLLECTION).document(req.senderId)
        
        FireStoreService.shared.getDocument(ref: ref,
                                            onCompletion: {(user:User?) in
            
            if let user = user {
                self.presenter?.onStateChange(state: .onUserReceived(user: user))
            }
            else{
                self.presenter?.onStateChange(state: .error(message: "Something went wrong.".localized))
            }
        })
        
    }
    
    func rejectRequest(_ req: Request) {
        guard let uid = FirebaseAuthService.shared.getUUID() else {return}
        
        let ref = dbRef.collection(FireStoreCollection.USER_COLLECTION)
            .document(uid)
            .collection(FireStoreCollection.USER_REQUESTS)
            .document(req.requestId)
            .updateData(["requestResponse":RequestResponseType.REJECTED.rawValue]) {error in
                if let error = error {
                    self.presenter?.onStateChange(state: .error(message: error.localizedDescription))
                }else {
                    self.presenter?.onStateChange(state: .changeResponseSucces)
                }
            }
    }
    
    func confirmRequest(_ req: Request) {
        
        guard let uid = FirebaseAuthService.shared.getUUID() else {return}
        
        let ref = dbRef.collection(FireStoreCollection.USER_COLLECTION)
            .document(uid)
            .collection(FireStoreCollection.USER_REQUESTS)
            .document(req.requestId)
            .updateData(["requestResponse":RequestResponseType.ACCEPTED.rawValue]) {error in
                if let error = error {
                    self.presenter?.onStateChange(state: .error(message: error.localizedDescription))
                }else {
                    self.createDualConnection(req.senderId, uid)
                }
            }
    }
    
    func createDualConnection(_ firstUser:String, _ secondUser:String) {
        
        if let connectionUid = [firstUser,secondUser].dualConnectionOut() {
            
            let dualConnection = DualConnection(connectionKey: connectionUid,
                                                timestamp: timeInSeconds(),
                                                lastMessage: "",
                                                lastMessageTimestamp: timeInSeconds())
            
            let ref = dbRef.collection(FireStoreCollection.DUAL_CONNECTION_COLLECTION)
                .document(connectionUid)
            
            FireStoreService.shared.pushDocument(dualConnection,
                                                 ref: ref, onCompletion: {status in
                if status == true {
                    self.presenter?.onStateChange(state: .changeResponseSucces)
                }else {
                    self.presenter?.onStateChange(state: .error(message: "Something went wrong.".localized))
                }
            })
        }
        
    }
    
}
