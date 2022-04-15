//
//  FireStorageService.swift
//  Logoo
//
//  Created by cemal tüysüz on 10.03.2022.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth


class FireStorageService {
    
    var storageRef:StorageReference!
    var fireStoreDB = Firestore.firestore()
    
    init(){
        storageRef = Storage.storage().reference()
    }
    
    static let shared:FireStorageService = {
        return FireStorageService()
    }()
    
    func pushPhoto(image:UIImage, filePath:String ,onCompletion: @escaping (String?, Error?) -> Void) {
        var data = Data()
        data = image.jpegData(compressionQuality: 0.8)!
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        // STARTED PHOTO UPLOAD
        storageRef.child(filePath).putData(data, metadata: metaData){(meta,error) in
            if let err = error {
                print("Error upload user photo : \(err.localizedDescription)")
                onCompletion(nil,err)
                return
            }
            self.storageRef.child(filePath).downloadURL{(url,error) in
                if let error = error {
                    onCompletion(nil,error)
                    print("Error when receive the user's profile photo url : \(error)")
                    return
                }
                if let ppUrl = url?.absoluteString {
                    onCompletion(ppUrl,nil)
                }
            }
        }
    }
}
