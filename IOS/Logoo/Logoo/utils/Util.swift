//
//  Util.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.01.2022.
//

import Foundation
import SystemConfiguration


func hobbyToHobbies(hobby:String) -> [String]{
    let hobbies = hobby.components(separatedBy: "&")
        return hobbies
}

func timeInSeconds() -> Int64 {
    return Int64(Date().timeIntervalSince1970 * 1000)
}

func milliSecondToDate(milliseconds:Int64) -> Date {
    return Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
}

func convertStringToDictionary(text: String) -> [String:AnyObject]? {
   if let data = text.data(using: .utf8) {
       do {
           let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
           return json
       } catch {
           print("Something went wrong")
       }
   }
   return nil
}


func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret
    }

extension String {
    func localized() -> String {
        return NSLocalizedString(self,
                                 tableName: "Localizable",
                                 bundle: .main,
                                 value: self,
                                 comment: self)
    }
}
