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
    
    func getInterests(_ pageLimit:Int) {
        
        // get query by lastSnapshot
        let query = getQuery(pageLimit)
        // Paginated Interests
        FireStoreService.shared.getCollection(query: query,
                                              onCompletion: {(interests:[Interest?]?, lastSnap,error) in
            
            if let error = error {
                print(error)
                if let _ = self.lastSnapshot {
                    self.presenter?.onStateChange(state: .getInterestError) // get paged data error
                }else {
                    // Starter data are null
                    // TODO: SHOW ERROR MESSAGE
                }
                return
            }
            var nonOptionalInterests = [Interest]()
            
            if let interests = interests {
                self.lastSnapshot = lastSnap
                for interest in interests {
                    if let interest = interest {
                        nonOptionalInterests.append(interest)
                    }
                }
            }
            // push paginated list to view
            self.presenter?.onStateChange(state: .interests(pagedInterests: nonOptionalInterests))
        })
    }
    
    func getUserInterests(){
        guard let uuid = Auth.auth().currentUser?.uid else {return}
        
        // user interests firestore reference
        let userInterestsRef = self.dbRef.collection(FireStoreCollection.USER_COLLECTION).document(uuid).collection(FireStoreCollection.USER_INTERESTS)
        
        FireStoreService.shared.getCollection(ref: userInterestsRef,
                                              onCompletion: {(interests:[Interest?]?,error) in
            
            if let error = error {
                print(error)
                return
            }
            
            var noOptionalUserInterests = [Interest]()
            if let interests = interests {
                for interest in interests {
                    if let interest = interest {
                        noOptionalUserInterests.append(interest)
                    }
                }
            }
            // push user's interests to view
            self.presenter?.onStateChange(state: .userInterests(userInterests: noOptionalUserInterests))
        })
    }
    
    func getQuery(_ limit:Int) -> Query{
        if let lastSnapshot = lastSnapshot {
            return dbRef.collection(FireStoreCollection.INTEREST_COLLECTION).limit(to: limit).start(afterDocument: lastSnapshot)
        }
        return dbRef.collection(FireStoreCollection.INTEREST_COLLECTION).limit(to: limit)
    }
    
    func saveInterests(list: [Interest]) {
        guard let uuid = FirebaseAuthService.shared.getUUID() else { return }
                
            presenter?.onStateChange(state: .showCurtain)
        
            let interestRef = dbRef.collection(FireStoreCollection.USER_COLLECTION).document(uuid).collection(FireStoreCollection.USER_INTERESTS)
            
            // get current lists
            FireStoreService.shared.getCollection(ref: interestRef, onCompletion: {(interests:[Interest?]?,error) in
                
                var nonOptionalList = [Interest]()
                
                if let interests = interests {
                    for interest in interests {
                        if let interest = interest {
                            nonOptionalList.append(interest)
                        }
                    }
                }
                if !nonOptionalList.isEmpty {
                    // Delete Current Interests
                    for item in nonOptionalList {
                        let ref = self.dbRef.collection(FireStoreCollection.USER_COLLECTION).document(uuid).collection(FireStoreCollection.USER_INTERESTS).document(item.interestKey)
                        
                        ref.delete(completion: {error in
                            guard let error = error else {
                                
                                if item.interestKey == nonOptionalList.last?.interestKey {
                                    // if last item deleted;
                                    if list.isEmpty {
                                        self.presenter?.onStateChange(state: .saveInterestsResponse(response: SimpleResponse(status: true)))
                                    }else {
                                        self.pushInterests(list, uuid: uuid)
                                    }
                                }
                                return
                            }
                            print(error)
                        })
                    }
                }else {
                    self.pushInterests(list, uuid: uuid)
                }

            })
    }
    
    private func pushInterests(_ interests:[Interest], uuid:String) {
        for item in interests {
            let ref = dbRef.collection(FireStoreCollection.USER_COLLECTION).document(uuid).collection(FireStoreCollection.USER_INTERESTS).document(item.interestKey)
            FireStoreService.shared.pushDocument(item, ref: ref, onCompletion: {status in
                
                if let status = status, status != false {
                    self.presenter?.onStateChange(state: .saveInterestsResponse(response: SimpleResponse(status: true)))
                }
                self.presenter?.onStateChange(state: .saveInterestsResponse(response: SimpleResponse(status: false, message: "ERROR MESSAGE")))
            })
        }
    }
    
    func searchInterest(searchText: String) {
        resetPagination()
        let key = (Locale.current.languageCode ?? "en" == "en") ? Interest.CodingKeys.interestEN.rawValue : Interest.CodingKeys.interestTR.rawValue
        
        let lessValue = searchText + "\u{f8ff}"
        let query = dbRef.collection(FireStoreCollection.INTEREST_COLLECTION)
            .whereField(key, isGreaterThanOrEqualTo: searchText)
            .whereField(key, isLessThanOrEqualTo: lessValue)
            
        
        FireStoreService.shared.getCollection(query: query, onCompletion: {(interests:[Interest?]?,_,error) in
            if let error = error {
                print(error)
                // show error
            }
            
            var nonOptionalInterests = [Interest]()
            if let interests = interests {
                for interest in interests {
                    if let interest = interest {
                        nonOptionalInterests.append(interest)
                    }
                }
                self.presenter?.onStateChange(state: .searchedInterests(interests: nonOptionalInterests))
            }
        })
    }
    
    func resetPagination() {
        lastSnapshot = nil
    }
    
    func deleteInterest(_ interestID: String) {
        guard let userUid = FirebaseAuthService.shared.getUUID() else {return}
        
        let document = dbRef.collection(FireStoreCollection.USER_COLLECTION).document(userUid).collection(FireStoreCollection.USER_INTERESTS).document(interestID)
        
        document.delete(completion: {error in
            if let error = error {
                print(error)
                // TODO: SHOW ERROR FOR INTEREST DELETE FAILED
            }
        })
    }
    
}
