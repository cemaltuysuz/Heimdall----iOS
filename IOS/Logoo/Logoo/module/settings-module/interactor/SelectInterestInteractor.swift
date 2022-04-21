//
//  SelectInterestInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 11.02.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import UIKit

class SelectInterestInteractor : PresenterToInteractorInterestSelectProtocol {
    
    var presenter: InteractorToPresenterInterestSelectProtocol?
    let dbRef = Firestore.firestore()
    var lastSnapshot:DocumentSnapshot?
    
    var interestPageLimit:Int = 20
    
    func getInterests() {
        
        guard let uuid = Auth.auth().currentUser?.uid else {return}
        let query = getQuery()
        FireStoreService.shared.getCollection(query: query,
                                              onCompletion: {(interests:[Interest?]?, lastSnap,error) in
            
            if let error = error {
                print(error)
                if let _ = self.lastSnapshot {
                    // TODO: Close pagination indicator
                }else {
                    // TODO: SHOW ERROR MESSAGE
                }
                return
            }
            self.lastSnapshot = lastSnap
            var nonOptionalInterests = [Interest]()
            
            if let interests = interests {
                for interest in interests {
                    if let interest = interest {
                        nonOptionalInterests.append(interest)
                    }
                }
            }
            self.presenter?.onStateChange(state: .interests(pagedInterests: nonOptionalInterests))
            
            let userDocumentRef = self.dbRef.collection(FireStoreCollection.USER_COLLECTION).document(uuid)
            FireStoreService.shared.getDocument(ref: userDocumentRef,
                                                onCompletion: {(user:User?) in
                if let user = user {
                    self.presenter?.onStateChange(state: .userInterests(userInterests: user.userInterests))
                }
            })
        })
    }
    
    func getQuery() -> Query{
        var query:Query!
        if let lastSnapshot = lastSnapshot {
            query = dbRef.collection(FireStoreCollection.INTEREST_COLLECTION).start(afterDocument: lastSnapshot)
        }else {
            query = dbRef.collection(FireStoreCollection.INTEREST_COLLECTION).limit(to: interestPageLimit)
        }
        return query
    }
    
    func saveInterests(list: [Interest]) {
        guard let uuid = FirebaseAuthService.shared.getUUID() else { return }
            
            dbRef.collection(FireStoreCollection.USER_COLLECTION)
                .document(uuid)
                .updateData(["userInterests":list]){error in
                    if let error = error {
                        self.presenter?.onStateChange(state: .saveInterestsResponse(response: SimpleResponse(status: false, message: error.localizedDescription)))
                        return
                    }
                    self.presenter?.onStateChange(state: .saveInterestsResponse(response: SimpleResponse(status: true, message: nil)))
                }
    }
    
    func searchInterest(searchText: String) {
/**
 var searchList = [InterestSelectionModel]()
 if !searchText.isEmpty {
     if !self.allHobbies!.isEmpty {
         for index in self.allHobbies! {
                 if index.interestTitle!.lowercased().contains(searchText.lowercased()) {
                     searchList.append(index)
                 }
             }
             self.presenter?.allHobies(hobbyList: searchList)
         }
 }else {
     self.presenter?.allHobies(hobbyList: self.allHobbies!)
 }
 */
    }
    
}
