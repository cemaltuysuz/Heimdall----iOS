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
    
    
    func pushPhoto(image:UIImage,ref:DocumentReference) {
            var data = Data()
            data = image.jpegData(compressionQuality: 0.8)!
            // converted the photo into data.
            // determine the path to the file where the photo will be uploaded and the name / type of the file.
            let fileUUID = UUID().uuidString
            let filePath = "profile/\(Auth.auth().currentUser!.uid)/\(fileUUID)"
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            
            // STARTED PHOTO UPLOAD
            storageRef.child(filePath).putData(data, metadata: metaData){(meta,error) in
                if let err = error {
                    print("Error upload user photo : \(err.localizedDescription)")
                    return
                }
                self.storageRef.child(filePath).downloadURL{(url,error) in
                    if let error = error {
                        print("Error when receive the user's profile photo url : \(error)")
                        return
                    }
                    if let ppUrl = url?.absoluteString {
                        let fields = [UserFieldType.USER_PHOTO.rawValue : ppUrl]
                        FireStoreService.shared.updateDocumentByField(ref: ref, fields: fields, onCompletion: {(response) in
                            if let status = response.status, status == true {
                                print("Photo upload is succeded.")
                            }else {
                                print("Photo upload is fail.")
                            }
                        })
                    }
                }
            }
        }
    }
