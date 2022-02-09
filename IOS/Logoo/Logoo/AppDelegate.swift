//
//  AppDelegate.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import DeviceKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if Auth.auth().currentUser != nil {
            if let userId = Auth.auth().currentUser?.uid{
                let ref = Database.database().reference().child("users").child(userId).child("isOnline")
                ref.setValue(false)
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if Auth.auth().currentUser != nil {
            if let userId = Auth.auth().currentUser?.uid{
                let dbRef = Database.database().reference()
                
                let onlineRef = dbRef.child("users").child(userId).child("isOnline") // user online state
                onlineRef.setValue(true)
                
                let logObject = [
                    "userLoginTime"     : timeInSeconds,
                    "deviceModel"       : Device.current.model ?? "unfounded",
                    "deviceVersion"     : Device.current.systemVersion ?? "unfounded",
                    "operatingSystem"   : "IOS"
                ] as [String : Any]
                
                let loginLogRef = dbRef.child("login-log").child(userId).child(UUID().uuidString)
                loginLogRef.setValue(logObject)
                
            }
        }
    }


}

