//
//  SceneDelegate.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import DeviceKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if Auth.auth().currentUser != nil {
            if let userId = Auth.auth().currentUser?.uid{
                let dbRef = Database.database().reference()
                let userRef = dbRef.child("users").child(userId)
                
                userRef.child("isOnline").setValue(true)
                
    
                
            }
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        if Auth.auth().currentUser != nil {
            if let userId = Auth.auth().currentUser?.uid{
                let ref = Database.database().reference().child("users").child(userId)
                
                ref.child("isOnline").setValue(false)
                
                let mills = timeInSeconds()
                ref.child("userLastSeen").setValue(mills)
            }
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

