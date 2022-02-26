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

class FireStoreService<T : Codable> :NSObject, Codable {
        
    func pushDocument(_ obj:T, ref:DocumentReference ,onCompletion: @escaping (Bool?) -> Void){
        do {
            try ref.setData(from: obj)
            onCompletion(true)
        }catch let error {
            print(error)
            onCompletion(false)
        }
    }
    
    
    func getDocument(ref: DocumentReference, onCompletion: @escaping (T?) -> Void){
        ref.getDocument{ (document,error) in
            if let error = error {
                print("hata var \(error.localizedDescription)")
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
    
    public func getDocumentsByField(ref:CollectionReference,getByField: String, getByValue: String,onCompletion: @escaping ([T?]?, Error?) -> Void) {
        var docs:[T] = []
        ref.whereField(getByField, isEqualTo: getByValue).getDocuments { query, error in
            if let error = error {
                print("hata var \(error.localizedDescription)")
                onCompletion(nil, error)
                print("A")
            } else {
                
                for document in query!.documents {
                    print("B")
                    print("\(document.documentID) => \(document.data())") // This line returns the snapshot documents correctly!
                    let doc = document as QueryDocumentSnapshot?
                    let result = Result {
                        try doc.flatMap {
                            try $0.data(as: T.self)
                        }
                    }
                    if let error = error {
                        print(error)
                        print("D")
                    }
                    switch result {
                    case .success(let uploadDocument) :
                        if let uploadDocument = uploadDocument {
                            docs.append(uploadDocument)
                        } else {
                            print("E")
                        }
                    case .failure(let error):
                        print("Error decoding Document \(error)")
                        onCompletion(nil, error)
                    }
                    print("dosyaaa \(docs.count)")
                }
                print("Gonderdik")
                onCompletion(docs, nil)
            }
        }
    }
}
