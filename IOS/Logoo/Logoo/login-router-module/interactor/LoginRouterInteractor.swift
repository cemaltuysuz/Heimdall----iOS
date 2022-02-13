//
//  LoginRouterInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 11.02.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class LoginRouterInteractor : PresenterToInteractorLoginRouterProtocol{
    var presenter: InteractorToPresenterLoginRouterProtocol?
    
    // Kullanıcıyı hangi sayfaya yönlendireceğimi belirliyorum.
    func route() {
        if let userID = Auth.auth().currentUser?.uid {
            let dbRef = Firestore.firestore()
            
            dbRef.collection("users").document("userID")

            dbRef.collection("users").document(userID).getDocument{ (document,error) in
                if let error = error {
                    print("hata var \(error.localizedDescription)")
                    return
                }
                if let document = document, document.exists {
                    let userBio = document.data()?["userHobbies"] as? String ?? ""
                    if userBio.isEmpty {
                        self.presenter?.loginToInterestSelectionVC(userId: userID)
                    }else {
                        self.presenter?.loginToHomeVC()
                    }
                }
            }
        }
    }
    
    
}
