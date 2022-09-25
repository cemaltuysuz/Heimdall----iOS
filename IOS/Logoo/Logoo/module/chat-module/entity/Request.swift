//
//  Request.swift
//  Logoo
//
//  Created by cemal tüysüz on 4.05.2022.
//

import Foundation

struct Request : Codable {
    var requestId:String!
    var senderId:String!
    var timestamp:Int64!
    var requestType:String!
    var requestResponse:String!
    
    func getRequestType() -> RequestType? {
        if let type = RequestType(rawValue: requestType) {
            return type
        }
        return nil
    }
}
