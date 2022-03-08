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
        var fields = [EditProfileConfigure]()
        if let currentUserId = Auth.auth().currentUser?.uid {
            let reference = Firestore.firestore().collection(FireCollections.USER_COLLECTION).document(currentUserId)
            FireStoreService.shared.getDocument(ref: reference, onCompletion: {(user:User?) in
                
                if let user = user {
                    fields.append(EditProfileConfigure(displayName: "Username".localized(),
                                                       value: user.username ?? "",
                                                       hasCheckForAlreadyUsed: true,
                                                       editType: .EDIT_WITH_TEXTFIELD, fieldType: .USERNAME,
                                                       validator: UsernameValidator()))
                    
                    fields.append(EditProfileConfigure(displayName: "Manifesto".localized(),
                                                       value: user.userManifesto ?? "",
                                                       hasCheckForAlreadyUsed: false,
                                                       editType: .EDIT_WITH_TEXTFIELD,
                                                       fieldType: .USER_MANIFESTO))
                    
                    fields.append(EditProfileConfigure(displayName: "Gender".localized(),
                                                       value: user.userGender ?? "",
                                                       hasCheckForAlreadyUsed: false,
                                                       editType: .EDIT_WITH_DATE_PICKER,
                                                       fieldType: .USER_GENDER))
                    
                    fields.append(EditProfileConfigure(displayName: "Date of birth".localized(),
                                                       value: user.userBirthDay ?? "",
                                                       hasCheckForAlreadyUsed: false,
                                                       editType: .EDIT_WITH_PICKER_VIEW,
                                                       fieldType: .USER_BIRTHDAY))
                    
                    self.presenter?.userFieldsToPresenter(fields: fields, userPhotoUrl: user.userPhotoUrl)
                }
            })
        }
    }
    
    func updateUserField(model: EditProfileConfigure, reformable: Reformable) {
        
        if let uuid = getCurrentUserUid() {
            let ref = Firestore.firestore().collection(FireCollections.USER_COLLECTION).document(uuid)
            
            FireStoreService.shared.updateDocumentByField(ref: ref, fields: [model.fieldType.rawValue : model.value], onCompletion: {status in
                if status.status! {
                    reformable.reformResponse(resp: SimpleResponse(status: true, message: status.message))
                }else {
                    reformable.reformResponse(resp: SimpleResponse(status: false, message: status.message))
                }
            })
        }
    }
}
