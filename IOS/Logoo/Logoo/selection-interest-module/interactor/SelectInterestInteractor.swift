//
//  SelectInterestInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 11.02.2022.
//

import Foundation
import FirebaseFirestore
import UIKit

class SelectInterestInteractor : PresenterToInteractorInterestSelectProtocol {
    var presenter: InteractorToPresenterInterestSelectProtocol?
    
    func getInterests(uuid: String) {
        print("method çağrıldu")
        let alreadyHobbies = [String]()
        var hobbyList = [String]()
        
        let dbRef = Firestore.firestore()
        /*
        dbRef.child("users").child(uuid).getData{ (error,snapshot) in
            if let error = error {
                print("hata var \(error.localizedDescription)")
                return
            }
            
            if let detail =  snapshot.value as? NSDictionary {
                let userBio = detail["userBio"] as? String ?? ""
                if !userBio.isEmpty {
                    alreadyHobbies = hobbyToHobbies(hobby: userBio)
                }
            }
        } */

        dbRef.collection("interests").getDocuments{(snapshot, error) in
            if let error = error {
                print("Errorrrr : \(error.localizedDescription)")
                return
            }else {
                guard let snap = snapshot else {
                    return}
                                
                for document in snap.documents {
                    //document.
                    let data = document.data()
                    print(data)
                    let interest = data["Interest"] as? String ?? ""
                    print(interest)
                    hobbyList.append(interest)
                }
                self.presenter?.hobbies(hobbyList: hobbyList, alreadyList: alreadyHobbies)
            }
            
            
            
        }
        
        
    }
    
}
