//
//  FirebaseAuthService.swift
//  Logoo
//
//  Created by cemal tüysüz on 6.04.2022.
//

import Foundation
import FirebaseAuth

class FirebaseAuthService {
    static let shared = FirebaseAuthService()

    func getUUID() -> String? {
        guard let uuid = Auth.auth().currentUser?.uid else {
            return nil
        }
        return uuid
    }

}
