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
    
    func getIconByAction() -> UIImage?{
        if let event = event, let type = LogEventType(rawValue: event) {
            switch type {
            case .USER_SIGN_IN:
                return UIImage() // TODO
            case .USER_SIGN_OUT:
                break
            case .USER_PASSWORD_CHANGE:
                break
            case .USER_MAIL_CHANGE:
                break
            }
        }
        return nil
    }
    
    func getTimeAsDate() -> Date? {
        if let timestamp = timestamp {
            return milliSecondToDate(milliseconds: timestamp)
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
