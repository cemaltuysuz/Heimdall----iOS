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
    
    private var allHobbies:[InterestSelectionModel]?
    
    init(){
        self.allHobbies = [InterestSelectionModel]()
    }
    
    func getInterests() {
        var alreadyHobbies = [String]()
        var hobbyList = [InterestSelectionModel]()
        
        guard let uuid = Auth.auth().currentUser?.uid else {return}
        
        dbRef.collection("users").document(uuid).getDocument{ (document,error) in
            if let error = error {
                print("hata var \(error.localizedDescription)")
                return
            }
            if let document = document, document.exists {
                let userInterests = document.data()?["userInterests"] as? String ?? ""
                if !userInterests.isEmpty {
                    alreadyHobbies = userInterests.toListByCharacter(GeneralConstant.INTEREST_SEPERATOR)
                    self.presenter?.userAlreadyHobbies(alreadyList: alreadyHobbies)
                }
            }
        }
        
        
        dbRef.collection("interests").getDocuments{(snapshot, error) in
            if let error = error {
                print("Error : \(error.localizedDescription)")
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
                
                self.allHobbies = hobbyList
                self.presenter?.allHobies(hobbyList: hobbyList)
            }
        }
    }
    
    func saveInterests(list: [String]) {
        if let uuid = Auth.auth().currentUser?.uid {
            var hobby:String = ""
            
            for index in list {
                hobby = (hobby + index)
                if index != list.last {
                    hobby = hobby + "&"
                }
            }
            dbRef.collection("users")
                .document(uuid)
                .updateData(["userInterests":hobby]){error in
                    if let error = error {
                        self.presenter?.indicatorVisibility(status: false)
                        self.presenter?.saveInterestsResponse(resp: Resource<Any>(status: .ERROR, data: nil, message: error.localizedDescription))
                        return
                    }
                    
                } 
            self.presenter?.indicatorVisibility(status: false)
            self.presenter?.saveInterestsResponse(resp: Resource<Any>(status: .SUCCESS, data: nil, message: nil))
        }
    }
    
    func searchInterest(searchText: String) {
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
    }
    
}
