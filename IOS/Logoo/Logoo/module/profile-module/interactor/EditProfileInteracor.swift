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

class EditProfileInteractor :PresenterToInteractorEditProfileProtocol {
    
    var presenter: InteractorToPresenterEditProfileProtocol?
    
    func getCurrentUserFields() {
        var fields = [EditFieldConfigure]()
        if let currentUserId = Auth.auth().currentUser?.uid {
            let reference = Firestore.firestore().collection(FireCollections.USER_COLLECTION).document(currentUserId)
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
                    
                    self.presenter?.userFieldsToPresenter(fields: fields, userPhotoUrl: user.userPhotoUrl)
                }
            })
        }
    }
    
    func updateUserField(key:String, value:String, reformable: Reformable) {
        
        if let uuid = getCurrentUserUid() {
            let ref = Firestore.firestore().collection(FireCollections.USER_COLLECTION).document(uuid)
            
            FireStoreService.shared.updateDocumentByField(ref: ref, fields: [key : value], onCompletion: {status in
                if status.status! {
                    reformable.reformResponse(resp: SimpleResponse(status: true, message: status.message))
                }else {
                    reformable.reformResponse(resp: SimpleResponse(status: false, message: status.message))
                }
            })
        }
    }
}
