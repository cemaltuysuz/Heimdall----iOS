//
//  Util.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.01.2022.
//

import Foundation
import SystemConfiguration
import UIKit
import Mantis



func timeInSeconds() -> Int64 {
    return Int64(Date().timeIntervalSince1970 * 1000)
}

func randomStringWithLength(len: Int) -> NSString {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    let randomString : NSMutableString = NSMutableString(capacity: len)
    
    for _ in 1...len{
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.character(at: Int(rand)))
    }
    
    return randomString
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

func openGalleryWithVC<T:UIViewController & UINavigationControllerDelegate>(_ viewController:T) where T : UIImagePickerControllerDelegate{
    
    let imagePicker = UIImagePickerController()
    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
        
        imagePicker.delegate = viewController
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
        viewController.present(imagePicker, animated: true, completion: nil)
    }
}

func startMantis<T:UIViewController & CropViewControllerDelegate>(viewController:T, image:UIImage, shapeType:CropShapeType){
    var config = Mantis.Config()
    config.cropShapeType = shapeType
    config.ratioOptions = []
    let cropViewController = Mantis.cropViewController(image: image,config: config)
    cropViewController.delegate = viewController
    viewController.present(cropViewController, animated: true)
}
