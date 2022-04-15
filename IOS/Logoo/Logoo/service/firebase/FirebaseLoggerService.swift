//
//  FirebaseLoggerService.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.03.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import DeviceKit

class FirebaseLoggerService {
    
    static let shared = FirebaseLoggerService()
    
    func login_log(){
        if let userId = Auth.auth().currentUser?.uid {
            let dbRef = Firestore.firestore()
            
            let systemInfo = SystemInfo(deviceModel: Device.current.name ?? "unknow",
                                        deviceVersion: Device.current.systemVersion ?? "unknow",
                                        operatingSystem: SystemType.IOS.rawValue)
            let userTransaction = UserTransaction(systemInfo: systemInfo,
                                                  event: LogEventType.USER_SIGN_IN.rawValue,
                                                  timestamp: timeInSeconds())
            
            let logRef = dbRef
                .collection(FireStoreCollection.LOG_COLLECTION)
                .document(userId)
                .collection(userId)
                .document(UUID().uuidString)
            
            FireStoreService.shared.pushDocument(userTransaction, ref: logRef, onCompletion: {status in
                if status == nil || status == false{
                    print("Error occurred while logging login.")
                }
            })
        }
    }
}
