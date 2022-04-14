//
//  EditProfileInteracotr.swift
//  Logoo
//
//  Created by cemal tüysüz on 1.03.2022.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth
import UIKit

class EditProfileInteractor :PresenterToInteractorEditProfileProtocol {
    var presenter: InteractorToPresenterEditProfileProtocol?
    
    func loadPage() {
        var fields = [EditFieldConfigure]()
        if let currentUserId = Auth.auth().currentUser?.uid {
            let reference = Firestore.firestore().collection(FireStoreCollection.USER_COLLECTION).document(currentUserId)
            FireStoreService.shared.getDocument(ref: reference, onCompletion: {(user:User?) in
                
                if let user = user {
                    fields.append(EditFieldConfigure(displayName: "Username".localized(),
                                                     key: UserFieldType.USERNAME.rawValue,
                                                     value: user.username ?? "",
                                                     hasCheckForAlreadyUsed: true,
                                                     editType: .EDIT_WITH_TEXTFIELD,
                                                     validator: UsernameValidator()))
                    
                    fields.append(EditFieldConfigure(displayName: "Manifesto".localized(),
                                                     key: UserFieldType.USER_MANIFESTO.rawValue,
                                                     value: user.userManifesto ?? "",
                                                     hasCheckForAlreadyUsed: false,
                                                     editType: .EDIT_WITH_TEXTFIELD))
                    
                    fields.append(EditFieldConfigure(displayName: "Gender".localized(),
                                                     key: UserFieldType.USER_GENDER.rawValue,
                                                     value: user.userGender ?? "",
                                                     hasCheckForAlreadyUsed: false,
                                                     editType: .EDIT_WITH_PICKER_VIEW))
                    
                    fields.append(EditFieldConfigure(displayName: "Date of birth".localized(),
                                                     key: UserFieldType.USER_BIRTHDAY.rawValue,
                                                     value: user.userBirthDay ?? "",
                                                     hasCheckForAlreadyUsed: false,
                                                     editType: .EDIT_WITH_DATE_PICKER))
                    
                    self.presenter?.onStateChange(state: .userFields(fields: fields))
                    self.presenter?.onStateChange(state: .userObject(user: (user)))
                    self.getUserposts()
                }
            })
        }
    }
    
    func updateUserField(key:String, value:String, reformable: Reformable) {
        
        if let uuid = FirebaseAuthService.shared.getUUID() {
            let ref = Firestore.firestore().collection(FireStoreCollection.USER_COLLECTION).document(uuid)
            
            FireStoreService.shared.updateDocumentByField(ref: ref, fields: [key : value], onCompletion: {status in
                if status.status! {
                    reformable.reformResponse(resp: SimpleResponse(status: true, message: status.message))
                }else {
                    reformable.reformResponse(resp: SimpleResponse(status: false, message: status.message))
                }
            })
        }
    }
    
    func deleteUserPost(imageUUID: String) {
        
    }
    
    func createNewUserPost(image: UIImage) {
        if let uuid = FirebaseAuthService.shared.getUUID() {
            presenter?.onStateChange(state: .showCurtain)
            let ref = Firestore.firestore().collection(FireStoreCollection.USER_COLLECTION).document(uuid).collection(FireStoreCollection.USER_POSTS).document(UUID().uuidString)
            
            let filePath = "\(FireStoragePath.USER_POST)/\(uuid)/\(UUID().uuidString)"
            
            FireStorageService.shared.pushPhoto(image: image, filePath: filePath, onCompletion: { (imageUrl:String?,error) in
                
                if let error = error {
                    print(error)
                    self.presenter?.onStateChange(state: .onPhotoUploadFail(message: error.localizedDescription))
                }
                if let imageUrl = imageUrl {
                    let postObject = UserPost(postUrl: imageUrl,
                                              timestamp: timeInSeconds(),
                                              userPostType: UserPostType.PHOTO.rawValue)
                    
                    FireStoreService.shared.pushDocument(postObject, ref: ref, onCompletion: { status in
                        if status ?? false {
                            self.getUserposts()
                        }else {
                            self.presenter?.onStateChange(state: .onPhotoUploadFail(message: nil))
                        }
                    })
                }else {
                    self.presenter?.onStateChange(state: .onPhotoUploadFail(message: "URL_NOT_FOUND_ERROR"))
                }
            })

        }
    }
    
    func updateUserPhoto(image: UIImage) {
        if let uid = FirebaseAuthService.shared.getUUID() {
            let ref = Firestore.firestore().collection(FireStoreCollection.USER_COLLECTION).document(uid)
            let filePath = "\(FireStoragePath.USER_PHOTO)/\(uid)/\(UUID().uuidString)"
            FireStorageService.shared.pushPhoto(image: image, filePath: filePath, onCompletion: { (imageUrl:String?,error) in
                
                guard let imageUrl = imageUrl else {
                    print(error ?? "not found error")
                    return
                }
                
                let fields = [UserFieldType.USER_PHOTO.rawValue : imageUrl]
                FireStoreService.shared.updateDocumentByField(ref: ref, fields: fields, onCompletion: {(response) in
                    if let status = response.status, status == true {
                        print("Photo upload is succeded.")
                    }else {
                        print("Photo upload is fail.")
                    }
                })
            })
        }
    }
    
    private func getUserposts(){
        guard let uuid = FirebaseAuthService.shared.getUUID() else {return}
        
        let ref = Firestore.firestore().collection(FireStoreCollection.USER_COLLECTION).document(uuid).collection(FireStoreCollection.USER_POSTS)
        FireStoreService.shared.getCollection(ref: ref, onCompletion: { (posts:[UserPost?]?,error:Error?) in
            
            if let error = error {
                print("error when get user posts \(error)")
                return
            }
            var nonOptionalUserPosts = [UserPost]()
            
            if let posts = posts {
                for post in posts {
                    if let post = post {
                        nonOptionalUserPosts.append(post)
                    }
                }
            }
            self.presenter?.onStateChange(state: .posts(posts: nonOptionalUserPosts.sorted(by: {$0.timestamp ?? 0 > $1.timestamp ?? 0})))
        })
    }
}
