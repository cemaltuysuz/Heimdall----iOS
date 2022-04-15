//
//  LoginTransaction.swift
//  Logoo
//
//  Created by cemal tüysüz on 15.03.2022.
//

import Foundation
import UIKit
import CloudKit

struct UserTransaction : Codable {
    
    var systemInfo:SystemInfo?
    var event:String?
    var timestamp:Int64?
    
    init(systemInfo:SystemInfo, event:String, timestamp:Int64){
        self.systemInfo = systemInfo
        self.event = event
        self.timestamp = timestamp
    }
    
    func getOSIcon() -> UIImage?{
        if let systemInfo = systemInfo, let os = systemInfo.operatingSystem, let type = SystemType(rawValue: os){
            switch type {
            case .ANDROID:
                return UIImage(named: "android")
            case .IOS:
                let image = UIImage(systemName: "applelogo")?.withTintColor(.black)
                return image
            }
        }
        return nil
    }
    
    func getTimeAsDate() -> Date? {
        if let timestamp = timestamp {
            return timestamp.milliSecondToDate()
        }
        return nil
    }
}

struct SystemInfo : Codable {
    
    var deviceModel:String?
    var deviceVersion:String?
    var operatingSystem:String?
    
    init(deviceModel: String? = nil, deviceVersion: String? = nil, operatingSystem: String? = nil) {
        self.deviceModel = deviceModel
        self.deviceVersion = deviceVersion
        self.operatingSystem = operatingSystem
    }
}
