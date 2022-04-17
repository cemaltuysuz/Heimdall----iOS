//
//  InterestSelectionModel.swift
//  Logoo
//
//  Created by cemal tüysüz on 12.02.2022.
//

import Foundation

struct InterestSelectionModel {
   // var interestKey:String?
    var interestTitle:String?
    var isSelected:Bool?
    
    init(title:String,status:Bool){
      //  self.interestKey = key
        self.interestTitle = title
        self.isSelected = status
    }
}
