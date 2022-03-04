//
//  FireStoreService.swift
//  Logoo
//
//  Created by cemal tüysüz on 25.02.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Runtime

class FireStoreService {
    
    static let shared:FireStoreService = {
       return FireStoreService()
    }()
        
    func pushDocument<T>(_ obj:T, ref:DocumentReference ,onCompletion: @escaping (Bool?) -> Void) where T:Codable{
        do {
            try ref.setData(from: obj)
            onCompletion(true)
        }catch let error {
            print(error)
            onCompletion(false)
        }
    }
    
    
    func getDocument<T>(ref: DocumentReference, onCompletion: @escaping (T?) -> Void) where T:Codable{
        ref.getDocument{ (document,error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            let result = Result {
                try document.flatMap {
                    try $0.data(as: T.self)
                 }
              }
            switch result {
            case .success(let doc):
                if let doc = doc {
                    onCompletion(doc)
                }else {
                    onCompletion(nil)
                }
                break
            default:
                onCompletion(nil)
                break
            }
         }
    }
    
    public func getDocumentsByField<T>(ref:CollectionReference,getByField: String, getByValue: String,onCompletion: @escaping ([T?]?, Error?) -> Void) where T:Codable {
        var docs:[T] = []
        ref.whereField(getByField, isEqualTo: getByValue).getDocuments { query, error in
            if let error = error {
                onCompletion(nil, error)
            } else {
                
                for document in query!.documents {
                    print("\(document.documentID) => \(document.data())") // This line returns the snapshot documents correctly!
                    let doc = document as QueryDocumentSnapshot?
                    let result = Result {
                        try doc.flatMap {
                            try $0.data(as: T.self)
                        }
                    }
                    if let error = error {
                        print(error)
                    }
                    switch result {
                    case .success(let uploadDocument) :
                        if let uploadDocument = uploadDocument {
                            docs.append(uploadDocument)
                        } else {
                        }
                    case .failure(let error):
                        print("Error decoding Document \(error)")
                        onCompletion(nil, error)
                    }
                }
                onCompletion(docs, nil)
            }
        }
    }
    
    public func updateDocumentByField(ref:DocumentReference,fields:[String:String],onCompletion: @escaping (SimpleResponse) -> Void) {
            ref.updateData(fields) {error in
                if let error = error {
                    onCompletion(SimpleResponse(status: false, message: error.localizedDescription))
                }
            }
        onCompletion(SimpleResponse(status: true, message: "Success".localized()))
    }
}
