//
//  P2P.swift
//  Logoo
//
//  Created by cemal tüysüz on 25.01.2022.
//

import Foundation

class P2P {
    var p2pId:String?
    var creationTime:String?
    var p2pMembers:[String]?
    
    init(){}
    
    init(p2pId:String, creationTime:String, p2pMembers:[String]){
        self.p2pId = p2pId
        self.creationTime = creationTime
        self.p2pMembers = p2pMembers
    }
}
