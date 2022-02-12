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
        var alreadyHobbies = [String]()
        var hobbyList = [InterestSelectionModel]()
        
        let dbRef = Firestore.firestore()
        
        dbRef.collection("users").document(uuid).getDocument{ (document,error) in
            if let error = error {
                print("hata var \(error.localizedDescription)")
                return
            }
            if let document = document, document.exists {
             let userBio = document.get("userBio") as? String ?? ""
                if !userBio.isEmpty {
                    alreadyHobbies = hobbyToHobbies(hobby: userBio)
                }
            }

        }
        
        alreadyHobbies.append("Home Repair")

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
                    let interest = data["Interest"] as? String ?? ""
                    if !interest.isEmpty {
                        hobbyList.append(
                            InterestSelectionModel(title: interest,
                                                   status: false))
                    }
                }
                self.presenter?.hobbies(hobbyList: hobbyList, alreadyList: alreadyHobbies)
            }
            
            
            
        }
        
        
    }
    
}
